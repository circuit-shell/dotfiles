local opt = vim.opt -- for conciseness

-- Netrw settings
vim.cmd("let g:netrw_liststyle = 3")

-- Telescope settings
vim.g.telescope_changed_files_base_branch = "main" -- can also use `:Telescope changed_files choose_base_branch`

-- Indentation settings
opt.expandtab = true -- expand tabs to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.tabstop = 2 -- number of spaces inserted for a tab
opt.shiftwidth = 2 -- number of spaces for indentation

-- Line wrapping
opt.wrap = true -- enable line wrapping
opt.linebreak = true -- wrap lines at convenient points

-- Folding settings
opt.foldcolumn = "1" -- width of the fold column
opt.foldlevel = 99 -- high fold level to start unfolded
opt.foldlevelstart = 99 -- high fold level when opening files
opt.foldenable = true -- enable folding
opt.fillchars = {
	foldclose = "", -- Symbol for open folds
	foldopen = "", -- Symbol for closed folds
	foldsep = "│", -- Symbol for fold separator
}

-- Line numbers and signs
opt.number = true -- show absolute line numbers
opt.relativenumber = true -- show relative line numbers
opt.signcolumn = "yes" -- always show sign column

-- Shada (shared data) settings
opt.shada = { "'10", "<0", "s10", "h" }
-- Search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- override ignorecase if search contains uppercase

-- Visual settings
opt.cursorline = true -- highlight the current cursor line
opt.termguicolors = true -- enable 24-bit RGB colors
opt.background = "dark" -- use dark version of colorscheme
opt.showmode = false -- don't show mode in command line

-- Editor behavior
opt.backspace = "indent,eol,start" -- allow backspace over everything
opt.virtualedit = "onemore" -- allow cursor one character beyond line end

-- Clipboard settings
opt.clipboard:append("unnamedplus") -- use system clipboard

-- Window splitting
opt.splitright = true -- split vertical windows to the right
opt.splitbelow = true -- split horizontal windows below

-- File handling
opt.swapfile = false -- disable swap file creation
