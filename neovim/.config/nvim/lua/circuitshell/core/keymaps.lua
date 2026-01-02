-- ============================================================================
-- LEADER KEY CONFIGURATION
-- ============================================================================

-- Set leader key to space
vim.g.mapleader = " "

-- Define keymap variable for convenience
local keymap = vim.keymap

-- ============================================================================
-- INSERT MODE KEYMAPS
-- ============================================================================

-- Exit insert mode with jk or fd
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "fd", "<ESC>", { desc = "Exit insert mode with fd" })

-- ============================================================================
-- SEARCH AND HIGHLIGHTS
-- ============================================================================

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- ============================================================================
-- EDITOR OPERATIONS
-- ============================================================================

-- Delete single character without copying into register
keymap.set("n", "x", '"_x', { desc = "Delete char without yanking" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- ============================================================================
-- BUFFER MANAGEMENT
-- ============================================================================

-- Select all buffer content
keymap.set("n", "<leader>ba", "ggVG", { desc = "Select all buffer content" })

-- Split buffers
keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split buffer vertically" })
keymap.set("n", "<leader>bc", "<C-w>s", { desc = "Split buffer horizontally" })

-- Reopen most recently closed buffer
keymap.set("n", "<leader>bu", function()
	local recent_files = vim.v.oldfiles
	for _, file in ipairs(recent_files) do
		if vim.fn.filereadable(file) == 1 then
			-- Check if buffer is not already open
			local is_open = false
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == file then
					is_open = true
					break
				end
			end
			if not is_open then
				vim.cmd("edit " .. vim.fn.fnameescape(file))
				break
			end
		end
	end
end, { desc = "Reopen most recently closed buffer" })

-- Open current buffer with default application (e.g., browser for HTML)
keymap.set("n", "<leader>oo", function()
	local filepath = vim.fn.expand("%:p")

	if filepath == "" then
		vim.notify("No file to open", vim.log.levels.WARN)
		return
	end

	-- Detect OS and use appropriate command
	local open_cmd
	if vim.fn.has("mac") == 1 then
		open_cmd = "open"
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open"
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start"
	else
		vim.notify("Unsupported operating system", vim.log.levels.ERROR)
		return
	end

	-- Execute command to open file with default app
	local cmd = string.format('%s "%s"', open_cmd, filepath)
	vim.fn.system(cmd)
	vim.notify("Opened " .. vim.fn.expand("%:t") .. " with default application", vim.log.levels.INFO)
end, { desc = "Open file with default application" })

-- ============================================================================
-- SAVE OPERATIONS
-- ============================================================================

-- Save file and session (works in insert, visual, and normal mode)
keymap.set(
	{ "i", "v", "n" },
	"<C-s>",
	"<ESC>:w<CR><ESC><cmd>AutoSession save<CR>",
	{ noremap = true, silent = true, desc = "Save file and session" }
)

-- ============================================================================
-- INDENTATION
-- ============================================================================

-- Indent with Tab in normal mode
keymap.set("n", "<Tab>", ">>", { noremap = true, desc = "Indent line" })
keymap.set("n", "<S-Tab>", "<<", { noremap = true, desc = "Unindent line" })

-- Indent in visual mode and maintain selection
keymap.set("v", "<Tab>", ">gv", { noremap = true, desc = "Indent and reselect" })
keymap.set("v", "<S-Tab>", "<gv", { noremap = true, desc = "Unindent and reselect" })

-- ============================================================================
-- FILETYPE CONFIGURATION
-- ============================================================================

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
	filename = {
		["Bogiefile"] = "yaml",
	},
})

-- ============================================================================
-- SPECIAL OPERATIONS
-- ============================================================================

-- Source change in nvim config
keymap.set("n", "<leader>os", ":update<CR> :source<CR>")
-- Paste without yanking selection in visual mode (currently disabled)
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking selection" })

-- ============================================================================
-- Folding section
-- ============================================================================

vim.keymap.set("n", "<CR>", function()
	-- Only override <CR> for these filetypes
	local allowed_filetypes = {
		-- General programming
		"lua", "python", "rust", "go", "c", "cpp", "java", "vim",
		-- Web - JavaScript/TypeScript
		"javascript", "typescript", "javascriptreact", "typescriptreact",
		"jsx", "tsx",
		-- Web - HTML/CSS
		"html", "htm", "css", "scss", "sass", "less", "stylus",
		-- Web - Frameworks & Templates
		"vue", "svelte", "astro", "ejs", "handlebars", "pug",
		"jinja", "twig", "liquid", "php", "eruby",
		-- Web - Backend
		"ruby", "elixir", "elm", "graphql",
		-- Mobile - Native
		"swift", "kotlin", "dart", "objc", "objcpp",
		-- Mobile/Web - Markup & Config
		"xml", "json", "yaml", "yml", "toml", "env", "dotenv",
		-- Documentation & Data
		"markdown", "md", "rst", "asciidoc", "org", "sql",
		-- DevOps & Scripts
		"dockerfile", "sh", "bash", "zsh", "fish", "make",
		-- Other common formats
		"proto", "prisma", "tf", "hcl", "nginx", "apache",
	}
	-- Check if we should use default <CR> behavior
	if vim.fn.getcmdwintype() ~= "" or
	   not vim.tbl_contains(allowed_filetypes, vim.bo.filetype) then
		return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
	end
	-- Toggle fold logic
	local line = vim.fn.line(".")
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz")
	end
end, { desc = "[P]Toggle fold" })
