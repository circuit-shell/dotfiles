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
keymap.set("n", "<leader>om", ":update<CR> :source<CR>")
-- Paste without yanking selection in visual mode (currently disabled)
-- vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking selection" })

-- ============================================================================
-- Folding section
-- ============================================================================

-- -- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- -- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
-- function _G.markdown_foldexpr()
-- 	local lnum = vim.v.lnum
-- 	local line = vim.fn.getline(lnum)
-- 	local heading = line:match("^(#+)%s")
-- 	if heading then
-- 		local level = #heading
-- 		if level == 1 then
-- 			-- Special handling for H1
-- 			if lnum == 1 then
-- 				return ">1"
-- 			else
-- 				local frontmatter_end = vim.b.frontmatter_end
-- 				if frontmatter_end and (lnum == frontmatter_end + 1) then
-- 					return ">1"
-- 				end
-- 			end
-- 		elseif level >= 2 and level <= 6 then
-- 			-- Regular handling for H2-H6
-- 			return ">" .. level
-- 		end
-- 	end
-- 	return "="
-- end

-- local function set_markdown_folding()
-- 	vim.opt_local.foldmethod = "expr"
-- 	vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
-- 	vim.opt_local.foldlevel = 99

-- 	-- Detect frontmatter closing line
-- 	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
-- 	local found_first = false
-- 	local frontmatter_end = nil
-- 	for i, line in ipairs(lines) do
-- 		if line == "---" then
-- 			if not found_first then
-- 				found_first = true
-- 			else
-- 				frontmatter_end = i
-- 				break
-- 			end
-- 		end
-- 	end
-- 	vim.b.frontmatter_end = frontmatter_end
-- end

-- -- Use autocommand to apply only to markdown files
-- --
-- --
-- --
-- vim.g.markdown_reccomend_style = 0

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = set_markdown_folding,
-- })

-- Function to fold all headings of a specific level
-- local function fold_headings_of_level(level)
-- 	-- Move to the top of the file without adding to jumplist
-- 	vim.cmd("keepjumps normal! gg")
-- 	-- Get the total number of lines
-- 	local total_lines = vim.fn.line("$")
-- 	for line = 1, total_lines do
-- 		-- Get the content of the current line
-- 		local line_content = vim.fn.getline(line)
-- 		-- "^" -> Ensures the match is at the start of the line
-- 		-- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
-- 		-- "%s" -> Matches any whitespace character after the "#" characters
-- 		-- So this will match `## `, `### `, `#### ` for example, which are markdown headings
-- 		if line_content:match("^" .. string.rep("#", level) .. "%s") then
-- 			-- Move the cursor to the current line without adding to jumplist
-- 			vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
-- 			-- Check if the current line has a fold level > 0
-- 			local current_foldlevel = vim.fn.foldlevel(line)
-- 			if current_foldlevel > 0 then
-- 				-- Fold the heading if it matches the level
-- 				if vim.fn.foldclosed(line) == -1 then
-- 					vim.cmd("normal! za")
-- 				end
-- 				-- else
-- 				--   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
-- 			end
-- 		end
-- 	end
-- end

-- local function fold_markdown_headings(levels)
-- 	-- I save the view to know where to jump back after folding
-- 	local saved_view = vim.fn.winsaveview()
-- 	for _, level in ipairs(levels) do
-- 		fold_headings_of_level(level)
-- 	end
-- 	vim.cmd("nohlsearch")
-- 	-- Restore the view to jump to where I was
-- 	vim.fn.winrestview(saved_view)
-- end

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- Keymap for folding markdown headings of level 1 or above
-- vim.keymap.set("n", "zj", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- vim.keymap.set("n", "<leader>mfj", function()
-- 	-- Reloads the file to refresh folds, otheriise you have to re-open neovim
-- 	vim.cmd("edit!")
-- 	-- Unfold everything first or I had issues
-- 	vim.cmd("normal! zR")
-- 	fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Fold all headings level 1 or above" })

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- Keymap for folding markdown headings of level 2 or above
-- -- I know, it reads like "madafaka" but "k" for me means "2"
-- vim.keymap.set("n", "zk", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- vim.keymap.set("n", "<leader>mfk", function()
-- 	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
-- 	vim.cmd("edit!")
-- 	-- Unfold everything first or I had issues
-- 	vim.cmd("normal! zR")
-- 	fold_markdown_headings({ 6, 5, 4, 3, 2 })
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Fold all headings level 2 or above" })

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- Keymap for folding markdown headings of level 3 or above
-- vim.keymap.set("n", "zl", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- vim.keymap.set("n", "<leader>mfl", function()
-- 	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
-- 	vim.cmd("edit!")
-- 	-- Unfold everything first or I had issues
-- 	vim.cmd("normal! zR")
-- 	fold_markdown_headings({ 6, 5, 4, 3 })
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Fold all headings level 3 or above" })

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- Keymap for folding markdown headings of level 4 or above
-- vim.keymap.set("n", "z;", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- vim.keymap.set("n", "<leader>mf;", function()
-- 	-- Reloads the file to refresh folds, otherwise you have to re-open neovim
-- 	vim.cmd("edit!")
-- 	-- Unfold everything first or I had issues
-- 	vim.cmd("normal! zR")
-- 	fold_markdown_headings({ 6, 5, 4 })
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
	-- Get the current line number
	local line = vim.fn.line(".")
	-- Get the fold level of the current line
	local foldlevel = vim.fn.foldlevel(line)
	if foldlevel == 0 then
		vim.notify("No fold found", vim.log.levels.INFO)
	else
		vim.cmd("normal! za")
		vim.cmd("normal! zz") -- center the cursor line on screen
	end
end, { desc = "[P]Toggle fold" })

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- Keymap for unfolding markdown headings of level 2 or above
-- -- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- -- zj, zk, zl, z; and zu respectively lamw25wmal
-- vim.keymap.set("n", "zu", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- vim.keymap.set("n", "<leader>mfu", function()
-- 	-- Reloads the file to reflect the changes
-- 	vim.cmd("edit!")
-- 	vim.cmd("normal! zR") -- Unfold all headings
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Unfold all headings level 2 or above" })

-- -- HACK: Fold markdown headings in Neovim with a keymap
-- -- https://youtu.be/EYczZLNEnIY
-- --
-- -- gk jummps to the markdown heading above and then folds it
-- -- zi by default toggles folding, but I don't need it lamw25wmal
-- vim.keymap.set("n", "zi", function()
-- 	-- "Update" saves only if the buffer has been modified since the last save
-- 	vim.cmd("silent update")
-- 	-- Difference between normal and normal!
-- 	-- - `normal` executes the command and respects any mappings that might be defined.
-- 	-- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
-- 	vim.cmd("normal gk")
-- 	-- This is to fold the line under the cursor
-- 	vim.cmd("normal! za")
-- 	vim.cmd("normal! zz") -- center the cursor line on screen
-- end, { desc = "[P]Fold the heading cursor currently on" })

-------------------------------------------------------------------------------
--                         End Folding section
-------------------------------------------------------------------------------
