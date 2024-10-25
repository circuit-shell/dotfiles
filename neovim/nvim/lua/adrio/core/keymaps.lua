-- set leader key to space
vim.g.mapleader = " "

-- define keymaps for consiseness
local keymap = vim.keymap

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- buffer navigation
keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split buffer vertically" }) -- split window vertically
keymap.set("n", "<leader>bc", "<C-w>s", { desc = "Split buffer horizontally" }) -- split window horizontally
keymap.set("n", "<leader>bx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>x", "<cmd>:bdelete<CR>", { desc = "Close current buffer" })
keymap.set("n", "<leader>]", "<cmd>bn<CR>", { desc = "Navigate to next buffer" })
keymap.set("n", "<leader>[", "<cmd>bp<CR>", { desc = "Navigate to previous buffer" })

-- close current buffer

-- Saving files
keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current file" })
keymap.set("v", "<C-s>", "<ESC>:w<CR>a", { desc = "Save current file" })
keymap.set("i", "<C-s>", "<ESC>:w<CR>a", { desc = "Save current file" })
