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


-- ============================================================================
-- SAVE OPERATIONS
-- ============================================================================

-- Save file and session (works in insert, visual, and normal mode)
keymap.set(
  { "i", "v", "n" },
  "<C-s>",
  "<ESC>:w<CR><ESC><cmd>SessionSave<CR>",
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
    ['http'] = 'http',
  },
  filename = {
    ['Bogiefile'] = 'yaml',
  },
})

-- ============================================================================
-- SPECIAL OPERATIOn
-- ============================================================================

-- Paste without yanking selection in visual mode (currently disabled)
-- vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without yanking selection" })

