local opt = vim.opt -- for conciseness

vim.cmd("let g:netrw_liststyle = 3")

-- Show line numbers and relative line numbers simultaneously
-- vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.opt.statuscolumn = "%s %=%l %=%r "
-- vim.opt.statuscolumn = '%s %#NonText#%=%{&nu?v:lnum:""}'
-- 	.. '%=%{&rnu&&(v:lnum%2)?"\\ ".v:relnum:""}'
-- 	.. '%#LineNr#%{&rnu&&!(v:lnum%2)?"\\ ".v:relnum:""}│ '
-- vim.opt.numberwidth = 4

-- Tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
