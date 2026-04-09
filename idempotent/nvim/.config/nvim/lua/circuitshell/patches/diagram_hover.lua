-- Vendored from 3rd/diagram.nvim lua/diagram/hover.lua with one fix:
-- Upstream used y = 5 with only 5 header lines → E966 (invalid line 6).
-- Anchor on the last header line (0-indexed). Buffer line count changes when help text grows.

local image_nvim = require("image")

local M = {}

local function show_loading_notification(diagram_type)
	vim.notify("Loading " .. diagram_type .. " diagram...", vim.log.levels.INFO, {
		timeout = 5000,
	})
end

local function show_ready_notification()
	vim.notify("✓ Diagram ready", vim.log.levels.INFO, {
		replace = true,
		timeout = 1500,
	})
end

local get_extended_range = function(bufnr, diagram)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local start_row = diagram.range.start_row
	local end_row = diagram.range.end_row

	for i = start_row, 0, -1 do
		local line = lines[i + 1]
		if line and line:match("^%s*```") then
			start_row = i
			break
		end
	end

	for i = end_row, #lines - 1 do
		local line = lines[i + 1]
		if line and line:match("^%s*```%s*$") then
			end_row = i
			break
		end
	end

	return {
		start_row = start_row,
		start_col = 0,
		end_row = end_row,
		end_col = 0,
	}
end

local get_diagram_at_cursor = function(bufnr, integrations)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1] - 1
	local _col = cursor[2]

	local ft = vim.bo[bufnr].filetype
	local integration = nil
	for _, integ in ipairs(integrations) do
		if vim.tbl_contains(integ.filetypes, ft) then
			integration = integ
			break
		end
	end

	if not integration then
		return nil
	end

	local diagrams = integration.query_buffer_diagrams(bufnr)
	for _, diagram in ipairs(diagrams) do
		local extended_range = get_extended_range(bufnr, diagram)

		if row >= extended_range.start_row and row <= extended_range.end_row then
			return diagram
		end
	end

	return nil
end

M.show_diagram_hover = function(diagram, integrations, renderer_options)
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	local integration = nil
	for _, integ in ipairs(integrations) do
		if vim.tbl_contains(integ.filetypes, ft) then
			integration = integ
			break
		end
	end

	if not integration then
		return
	end

	local renderer = nil
	for _, r in ipairs(integration.renderers) do
		if r.id == diagram.renderer_id then
			renderer = r
			break
		end
	end

	if not renderer then
		vim.notify("No renderer found for " .. diagram.renderer_id, vim.log.levels.ERROR)
		return
	end

	local options = renderer_options[renderer.id] or {}
	local renderer_result = renderer.render(diagram.source, options)

	local function show_in_tab()
		if vim.fn.filereadable(renderer_result.file_path) == 0 then
			vim.notify("Diagram file not found: " .. renderer_result.file_path, vim.log.levels.ERROR)
			return
		end

		show_ready_notification()

		vim.cmd("tabnew")
		local buf = vim.api.nvim_get_current_buf()
		local win = vim.api.nvim_get_current_win()

		vim.api.nvim_buf_set_name(buf, diagram.renderer_id .. " diagram")
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].swapfile = false

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
			"# " .. diagram.renderer_id:upper() .. " Diagram",
			"",
			"Press 'q' / Esc to close   'o' open in system viewer",
			"Zoom: = + in   - _ out   zr reset",
			"Pan (oversized diagram): h j k l or arrows (view scrolls to keep image)",
			"",
		})

		-- 6 header lines → rows 0..5; image anchors on final blank line (avoid E966).
		local BASE_ROW = 5

		local image = image_nvim.from_file(renderer_result.file_path, {
			buffer = buf,
			window = win,
			with_virtual_padding = true,
			inline = true,
			x = 0,
			y = BASE_ROW,
		})

		-- Allow zoom past global image.nvim max_*_window_percentage in this preview tab.
		if image then
			image.ignore_global_max_size = true
		end

		-- Max scale vs first-fit size; diagram may exceed window → Kitty/image.nvim crops; pan shifts anchor.
		local ZOOM_MAX = 48.0
		local PAN_STEP = 2

		local zoom = 1.0
		local pan_x, pan_y = 0, 0
		local base_w, base_h ---@type number?, number?

		local function capture_bases()
			if not image or base_w then
				return
			end
			local rg = image.rendered_geometry
			if rg and rg.width and rg.height and rg.width > 0 and rg.height > 0 then
				base_w = rg.width
				base_h = rg.height
				zoom = 1.0
				pan_x = 0
				pan_y = 0
			end
		end

		--- Avoid absurd magick/kitty work; still allows multi-window-size diagrams for panning.
		local function cap_dims(w, h)
			local win_w = vim.api.nvim_win_get_width(win)
			local win_h = vim.api.nvim_win_get_height(win)
			local wmax = math.max(win_w * 10, 64)
			local hmax = math.max(win_h * 10, 32)
			return math.max(1, math.min(w, wmax)), math.max(1, math.min(h, hmax))
		end

		--- Keep pan in a range so some of the image stays visible (image.nvim clears if fully OOB).
		local function clamp_pan(w, h)
			local win_w = vim.api.nvim_win_get_width(win)
			local win_h = vim.api.nvim_win_get_height(win)
			if w <= win_w + 1 then
				pan_x = 0
			else
				local xmin = -(w - win_w + 2)
				pan_x = math.max(xmin, math.min(0, pan_x))
			end
			if h <= win_h + 1 then
				pan_y = 0
			else
				local ymax = math.max(0, h - win_h + 4)
				pan_y = math.max(0, math.min(ymax, pan_y))
			end
		end

		--- image.nvim uses screenpos(win, y + 1, …); y is 0-indexed → need #lines >= y + 1.
		local function ensure_anchor_line_exists()
			local y = BASE_ROW + pan_y
			if y < 0 then
				y = 0
			end
			local n = #vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local need = (y + 1) - n
			if need > 0 then
				local filler = {}
				for _ = 1, need do
					filler[#filler + 1] = ""
				end
				vim.api.nvim_buf_set_lines(buf, n, n, false, filler)
			end
		end

		--- If the anchor row is outside the visible window, image.nvim refuses to draw (returns false).
		--- Put the anchor on the first visible line so tall virtual-padding images stay on-screen.
		local function scroll_anchor_into_view()
			local y0 = BASE_ROW + pan_y
			local line_1 = math.max(1, y0 + 1)
			local lc = vim.api.nvim_buf_line_count(buf)
			if line_1 > lc then
				line_1 = lc
			end
			vim.api.nvim_win_set_cursor(win, { line_1, 0 })
			vim.api.nvim_win_call(win, function()
				pcall(vim.cmd, "silent! normal! zt")
			end)
		end

		local function apply_view()
			if not image or not base_w or not base_h then
				return
			end
			local w = math.floor(base_w * zoom)
			local h = math.floor(base_h * zoom)
			w, h = cap_dims(w, h)
			clamp_pan(w, h)
			ensure_anchor_line_exists()
			scroll_anchor_into_view()
			image:render({
				width = w,
				height = h,
				x = pan_x,
				y = BASE_ROW + pan_y,
			})
		end

		local function zoom_in()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = math.min(zoom * 1.15, ZOOM_MAX)
			apply_view()
		end

		local function zoom_out()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = math.max(zoom / 1.15, 0.15)
			apply_view()
		end

		local function zoom_reset()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = 1.0
			pan_x = 0
			pan_y = 0
			apply_view()
		end

		-- h / Left: show more of the left side; l / Right: more right (negative pan_x shifts drawable left).
		local function pan_left()
			if not base_w then
				return
			end
			pan_x = pan_x + PAN_STEP
			apply_view()
		end
		local function pan_right()
			if not base_w then
				return
			end
			pan_x = pan_x - PAN_STEP
			apply_view()
		end
		-- j / Down: move diagram down → see upper area less, lower more
		local function pan_down()
			if not base_h then
				return
			end
			pan_y = pan_y + PAN_STEP
			apply_view()
		end
		local function pan_up()
			if not base_h then
				return
			end
			pan_y = pan_y - PAN_STEP
			apply_view()
		end

		if image then
			ensure_anchor_line_exists()
			scroll_anchor_into_view()
			image:render()
			capture_bases()
		else
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
				"Image display failed. File: " .. renderer_result.file_path,
			})
		end

		local map_opts = { buffer = buf }
		vim.keymap.set("n", "=", zoom_in, vim.tbl_extend("force", map_opts, { desc = "Diagram zoom in" }))
		vim.keymap.set("n", "+", zoom_in, vim.tbl_extend("force", map_opts, { desc = "Diagram zoom in" }))
		vim.keymap.set("n", "-", zoom_out, vim.tbl_extend("force", map_opts, { desc = "Diagram zoom out" }))
		vim.keymap.set("n", "_", zoom_out, vim.tbl_extend("force", map_opts, { desc = "Diagram zoom out" }))
		vim.keymap.set("n", "zr", zoom_reset, vim.tbl_extend("force", map_opts, { desc = "Diagram zoom reset" }))

		local pan_desc = { desc = "Diagram pan" }
		vim.keymap.set("n", "h", pan_left, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "l", pan_right, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "j", pan_down, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "k", pan_up, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "<Left>", pan_left, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "<Right>", pan_right, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "<Down>", pan_down, vim.tbl_extend("force", map_opts, pan_desc))
		vim.keymap.set("n", "<Up>", pan_up, vim.tbl_extend("force", map_opts, pan_desc))

		vim.keymap.set("n", "q", function()
			if image then
				image:clear()
			end
			vim.cmd("tabclose")
		end, { buffer = buf, desc = "Close diagram tab" })

		vim.keymap.set("n", "<Esc>", function()
			if image then
				image:clear()
			end
			vim.cmd("tabclose")
		end, { buffer = buf, desc = "Close diagram tab" })

		vim.keymap.set("n", "o", function()
			vim.ui.open(renderer_result.file_path)
		end, { buffer = buf, desc = "Open image with system viewer" })
	end

	if renderer_result.job_id then
		local timer = vim.loop.new_timer()
		if not timer then
			return
		end
		timer:start(
			0,
			100,
			vim.schedule_wrap(function()
				local result = vim.fn.jobwait({ renderer_result.job_id }, 0)
				if result[1] ~= -1 then
					if timer:is_active() then
						timer:stop()
					end
					if not timer:is_closing() then
						timer:close()
						show_in_tab()
					end
				end
			end)
		)
	else
		show_in_tab()
	end
end

M.hover_at_cursor = function(integrations, renderer_options)
	local bufnr = vim.api.nvim_get_current_buf()
	local diagram = get_diagram_at_cursor(bufnr, integrations)

	if not diagram then
		vim.notify("No diagram found at cursor", vim.log.levels.INFO)
		return
	end

	show_loading_notification(diagram.renderer_id)
	M.show_diagram_hover(diagram, integrations, renderer_options)
end

return M
