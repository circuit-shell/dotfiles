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
			"Press 'q' to close this tab",
			"Press 'o' to open image with system viewer",
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

		if image then
			image:render()
		else
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
				"Image display failed. File: " .. renderer_result.file_path,
			})
		end

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
