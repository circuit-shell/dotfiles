-- Vendored from 3rd/diagram.nvim lua/diagram/hover.lua with one fix:
-- Upstream uses y = 5 while the header buffer only has 5 lines (0-indexed rows 0–4).
-- image.nvim calls screenpos(win, y + 1, ...) → line 6 → E966 Invalid line number.
-- Anchor on the last line: y = 4. Track: https://github.com/3rd/diagram.nvim (hover tab + image.nvim)

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
			"Zoom: = or + in   - or _ out   zr reset",
			"",
		})

		local image = image_nvim.from_file(renderer_result.file_path, {
			buffer = buf,
			window = win,
			with_virtual_padding = true,
			inline = true,
			x = 0,
			y = 4,
		})

		-- Allow zoom past global image.nvim max_*_window_percentage in this preview tab.
		if image then
			image.ignore_global_max_size = true
		end

		-- Max scale vs first-fit size (still clamped to window by apply_zoom).
		local ZOOM_MAX = 48.0

		local zoom = 1.0
		local base_w, base_h ---@type number?, number?

		local function capture_bases()
			if not image then
				return
			end
			local rg = image.rendered_geometry
			if rg and rg.width and rg.height and rg.width > 0 and rg.height > 0 then
				base_w = rg.width
				base_h = rg.height
				zoom = 1.0
			end
		end

		local function clamp_dims(w, h)
			local win_w = vim.api.nvim_win_get_width(win)
			local win_h = vim.api.nvim_win_get_height(win)
			w = math.min(w, math.max(1, win_w - 1))
			h = math.min(h, math.max(1, win_h - 2))
			return math.max(1, w), math.max(1, h)
		end

		local function apply_zoom()
			if not image or not base_w or not base_h then
				return
			end
			local w = math.floor(base_w * zoom)
			local h = math.floor(base_h * zoom)
			w, h = clamp_dims(w, h)
			image:render({ width = w, height = h })
		end

		local function zoom_in()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = math.min(zoom * 1.15, ZOOM_MAX)
			apply_zoom()
		end

		local function zoom_out()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = math.max(zoom / 1.15, 0.15)
			apply_zoom()
		end

		local function zoom_reset()
			if not base_w then
				capture_bases()
			end
			if not base_w then
				return
			end
			zoom = 1.0
			apply_zoom()
		end

		if image then
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
