-- Lightweight markdown helpers (no image.nvim / diagram.nvim).

local M = {}

---@param bufnr integer
---@return string|nil
local function mermaid_source_at_cursor(bufnr)
	local node = vim.treesitter.get_node({ bufnr = bufnr })
	while node do
		if node:type() == "fenced_code_block" then
			local lang, content
			for i = 0, node:named_child_count() - 1 do
				local c = node:named_child(i)
				if c:type() == "info_string" then
					lang = vim.trim(vim.treesitter.get_node_text(c, bufnr))
				elseif c:type() == "code_fence_content" then
					content = vim.treesitter.get_node_text(c, bufnr)
				end
			end
			if lang == "mermaid" and content and content ~= "" then
				return content
			end
		end
		node = node:parent()
	end
	return nil
end

--- link_destination often sits under anonymous nodes; walk all children.
---@param node userdata
---@param bufnr integer
---@return string|nil
local function find_link_destination_in_tree(node, bufnr)
	if node:type() == "link_destination" then
		local text = vim.treesitter.get_node_text(node, bufnr)
		return (text:gsub("^<(.+)>$", "%1"))
	end
	for i = 0, node:child_count() - 1 do
		local c = node:child(i)
		if c then
			local dest = find_link_destination_in_tree(c, bufnr)
			if dest then
				return dest
			end
		end
	end
	return nil
end

--- Fallback when injections / node names differ: cursor inside ![…](url) on this line.
---@param bufnr integer
---@param row0 integer 0-indexed line
---@param col0 integer 0-indexed byte column
---@return string|nil
local function image_url_on_line_at_col(bufnr, row0, col0)
	local line = (vim.api.nvim_buf_get_lines(bufnr, row0, row0 + 1, false) or {})[1] or ""
	local search_from = 1
	while true do
		local bang = line:find("![", search_from, true)
		if not bang then
			break
		end
		local close_bracket = line:find("]", bang + 2, true)
		if not close_bracket or line:sub(close_bracket + 1, close_bracket + 1) ~= "(" then
			search_from = bang + 2
		else
			local url_start = close_bracket + 2
			local close_paren = line:find(")", url_start, true)
			if not close_paren then
				break
			end
			local span_start0 = bang - 1
			local span_end0 = close_paren - 1
			if col0 >= span_start0 and col0 <= span_end0 then
				local raw = line:sub(url_start, close_paren - 1)
				return vim.trim((raw:gsub("^<(.+)>$", "%1")))
			end
			search_from = close_paren + 1
		end
	end
	return nil
end

---@param bufnr integer
---@return string|nil
local function image_destination_at_cursor(bufnr)
	local row1, col0 = unpack(vim.api.nvim_win_get_cursor(0))
	local row0 = row1 - 1

	local node = vim.treesitter.get_node({ bufnr = bufnr })
	while node do
		if node:type() == "image" then
			local dest = find_link_destination_in_tree(node, bufnr)
			if dest and dest ~= "" then
				return dest
			end
		end
		node = node:parent()
	end

	return image_url_on_line_at_col(bufnr, row0, col0)
end

---@param ref string
---@param bufnr integer
---@return string
local function resolve_ref(ref, bufnr)
	if ref:match("^https?://") or ref:match("^file:") then
		return ref
	end
	local path = ref
	if path:sub(1, 2) == "./" or (path:sub(1, 1) ~= "/" and not path:match("^%a:")) then
		local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
		if base == "" or base == "." then
			base = vim.fn.getcwd()
		end
		path = base .. "/" .. path
	end
	return vim.fn.fnamemodify(path, ":p")
end

function M.open_mermaid_in_viewer()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].filetype ~= "markdown" then
		return
	end
	local src = mermaid_source_at_cursor(bufnr)
	if not src then
		vim.notify("No mermaid ``` block under cursor", vim.log.levels.WARN)
		return
	end
	if vim.fn.executable("mmdc") ~= 1 then
		vim.notify("mmdc (mermaid-cli) not found in PATH", vim.log.levels.ERROR)
		return
	end
	local inp = vim.fn.tempname() .. ".mmd"
	local outp = vim.fn.tempname() .. ".svg"
	local lines = {}
	for line in vim.gsplit(src, "\n", { plain = true }) do
		lines[#lines + 1] = line
	end
	vim.fn.writefile(lines, inp)
	local cmd = {
		"mmdc",
		"-i",
		inp,
		"-o",
		outp,
		"-t",
		"forest",
		"-s",
		"3",
	}
	local r = vim.system(cmd):wait()
	vim.fn.delete(inp)
	if r.code ~= 0 then
		vim.notify("mmdc failed:\n" .. (r.stderr or ""), vim.log.levels.ERROR)
		if vim.fn.filereadable(outp) == 1 then
			vim.fn.delete(outp)
		end
		return
	end
	if vim.fn.filereadable(outp) ~= 1 then
		vim.notify("mmdc produced no output file", vim.log.levels.ERROR)
		return
	end
	M._open_external(outp)
end

function M.open_markdown_image_in_viewer()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].filetype ~= "markdown" then
		return
	end
	local dest = image_destination_at_cursor(bufnr)
	if not dest or dest == "" then
		vim.notify("No ![image](…) under cursor", vim.log.levels.WARN)
		return
	end
	local path = resolve_ref(vim.trim(dest), bufnr)
	if path:match("^https?://") then
		M._open_external(path)
		return
	end
	if vim.fn.filereadable(path) ~= 1 then
		vim.notify("File not found: " .. path, vim.log.levels.ERROR)
		return
	end
	M._open_external(path)
end

---@param path string
function M._open_external(path)
	if vim.ui and vim.ui.open then
		vim.ui.open(path)
	elseif vim.fn.has("macunix") == 1 then
		vim.fn.system({ "open", path })
	else
		vim.notify("Cannot open (no vim.ui.open): " .. path, vim.log.levels.WARN)
	end
end

function M.copy_fenced_code_block()
	local bufnr = vim.api.nvim_get_current_buf()
	local node = vim.treesitter.get_node({ bufnr = bufnr })
	while node do
		if node:type() == "fenced_code_block" then
			for i = 0, node:named_child_count() - 1 do
				local child = node:named_child(i)
				if child and child:type() == "code_fence_content" then
					local sr, _, er, _ = child:range()
					local lines = vim.api.nvim_buf_get_lines(bufnr, sr, er, false)
					vim.fn.setreg("+", table.concat(lines, "\n"))
					vim.notify("Code block copied!", vim.log.levels.INFO)
					return
				end
			end
		end
		node = node:parent()
	end
	vim.notify("No code block under cursor", vim.log.levels.WARN)
end

return M
