return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Added to satisfy LuaLS type annotations:
        modules = {},
        sync_install = false,
        ignore_install = {},

        ensure_installed = {
          "angular",
          "astro",
          "bash",
          "c",
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "html",
          "http",
          "java",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "php",
          "python",
          "query",
          "ruby",
          "rust",
          "scss",
          "svelte",
          "tsx",
          "typescript",
          "typst",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        auto_install = false,
      })

      local selection_stack = {}

      local function select_node(node)
        local sr, sc, er, ec = node:range()
        vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
        vim.fn.setpos("'>", { 0, er + 1, ec, 0 })
        vim.cmd("normal! gv")
      end

      vim.keymap.set({ "n", "x" }, "<C-space>", function()
        local node = vim.treesitter.get_node()
        if not node then return end

        if vim.fn.mode() ~= "n" then
          table.insert(selection_stack, node)
          node = node:parent()
          if not node then return end
        else
          selection_stack = {}
        end

        select_node(node)
      end, { desc = "Incremental treesitter selection" })

      vim.keymap.set("x", "<bs>", function()
        local prev = table.remove(selection_stack)
        if not prev then return end

        select_node(prev)
      end, { desc = "Shrink treesitter selection" })
    end,
  },
}
