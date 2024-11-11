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

-- set leader ba to select all buffer content
keymap.set("n", "<leader>ba", "ggVG", { desc = "Select all buffer content" })
-- buffer navigation
keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split buffer vertically" }) -- split window vertically
keymap.set("n", "<leader>bc", "<C-w>s", { desc = "Split buffer horizontally" }) -- split window horizontally

-- for normal mode save C-s
-- keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current file" })
keymap.set(
	{ "i", "v", "n" },
	"<C-s>",
	"<ESC>:w<CR><ESC><cmd>SessionSave<CR>",
	{ noremap = true, silent = true, desc = "Save file and switch back to normal mode" }
)

-- vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking selection" })
