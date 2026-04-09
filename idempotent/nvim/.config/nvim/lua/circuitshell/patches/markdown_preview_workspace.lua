---Fix selimacerbas/markdown-preview.nvim local images for live-server.nvim.
---
---1) Workspace = directory of the markdown file (not ~/.cache). The preview writes
---   content.md + index.html there (gitignore those + .mp-media-cache/).
---
---2) live-server uses fs_realpath + path_has_prefix; symlinked files resolve outside
---   the server root and get 404. No symlinks.
---
---3) The browser resolves image URLs against http://host:port/ (not the .md path).
---   We rewrite local ![](...) targets to URL paths under the server root: paths that
---   already sit under that directory become /relative/url; paths outside are copied
---   into .mp-media-cache/ so realpath stays under root.
---
---Requires instance_mode = "multi" (takeover uses shared cache only).
local M = {}

local function relpath_under(root, path)
	root = vim.fn.fnamemodify(root, ":p"):gsub("/+$", "")
	path = vim.fn.fnamemodify(path, ":p")
	local prefix = root .. "/"
	if path:sub(1, #prefix) == prefix then
		return path:sub(#prefix + 1)
	end
	return nil
end

---Split `path` or `path "title"` into path and optional `"title"` fragment (with quotes).
local function split_link_inner(inner)
	inner = inner:match("^%s*(.-)%s*$") or inner
	local path_part, title_part = inner:match("^(.-)%s+(\"[^\"]*\")%s*$")
	if path_part and title_part then
		path_part = path_part:match("^%s*(.-)%s*$") or path_part
		return path_part, title_part
	end
	return inner, nil
end

local function copy_file_bin(src, dest)
	local r = io.open(src, "rb")
	if not r then
		return false
	end
	local data = r:read("*a")
	r:close()
	local w = io.open(dest, "wb")
	if not w then
		return false
	end
	w:write(data or "")
	w:close()
	return true
end

---Return HTTP path like /assets/foo.png or /.mp-media-cache/abc.png
local function ensure_served_url(ws_root, abs_file)
	abs_file = vim.fn.fnamemodify(abs_file, ":p")
	local rel = relpath_under(ws_root, abs_file)
	if rel then
		return "/" .. rel:gsub("\\", "/")
	end

	local cache_dir = vim.fs.joinpath(ws_root, ".mp-media-cache")
	vim.fn.mkdir(cache_dir, "p")
	local sha = vim.fn.sha256(abs_file)
	local ext = abs_file:match("%.([^./\\]+)$") or "bin"
	local base = sha:sub(1, 24) .. "." .. ext
	local dest = vim.fs.joinpath(cache_dir, base)
	if vim.fn.filereadable(dest) ~= 1 then
		copy_file_bin(abs_file, dest)
	end
	return "/.mp-media-cache/" .. base
end

function M.rewrite_local_image_urls(text, ws_root)
	if not text or text == "" or not ws_root or ws_root == "" then
		return text
	end
	ws_root = vim.fn.fnamemodify(ws_root, ":p")

	return (text:gsub("(%![%[][^%]]*%][%(])([^)]+)([%)])", function(prefix, inner, suffix)
		local raw, title_frag = split_link_inner(inner)
		if not raw or raw == "" then
			return prefix .. inner .. suffix
		end
		if raw:find("^[a-zA-Z][a-zA-Z+.-]*:") then
			return prefix .. inner .. suffix
		end

		local abs
		if raw:sub(1, 1) == "/" then
			abs = vim.fn.fnamemodify(raw, ":p")
		else
			abs = vim.fn.fnamemodify(vim.fs.joinpath(ws_root, raw), ":p")
		end
		if vim.fn.filereadable(abs) ~= 1 then
			return prefix .. inner .. suffix
		end

		local url_path = ensure_served_url(ws_root, abs)
		local new_inner = url_path .. (title_frag and (" " .. title_frag) or "")
		return prefix .. new_inner .. suffix
	end))
end

function M.patch_workspace_for_buffer()
	local util = require("markdown_preview.util")
	if util._circuitshell_workspace_patched then
		return
	end
	util._circuitshell_workspace_patched = true

	local orig = util.workspace_for_buffer

	function util.workspace_for_buffer(bufnr)
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name == "" or vim.fn.filereadable(name) ~= 1 then
			return orig(bufnr)
		end
		return vim.fn.fnamemodify(name, ":p:h")
	end
end

function M.patch_write_text_rewrite_images()
	local util = require("markdown_preview.util")
	if util._circuitshell_write_patched then
		return
	end
	util._circuitshell_write_patched = true

	local orig = util.write_text

	function util.write_text(path, text)
		if type(path) == "string" and path:match("content%.md$") and type(text) == "string" then
			local mp = package.loaded["markdown_preview"]
			local bufnr = mp and mp._active_bufnr
			local name = bufnr and vim.api.nvim_buf_get_name(bufnr) or ""
			if name ~= "" and vim.fn.filereadable(name) == 1 then
				local ws_root = vim.fn.fnamemodify(name, ":p:h")
				text = M.rewrite_local_image_urls(text, ws_root)
			end
		end
		return orig(path, text)
	end
end

return M
