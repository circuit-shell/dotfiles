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
			require("nvim-treesitter").setup({})

			local parsers = {
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
			}

			local installed = require("nvim-treesitter").get_installed()
			local installed_set = {}
			for _, lang in ipairs(installed) do
				installed_set[lang] = true
			end
			local missing = {}
			for _, lang in ipairs(parsers) do
				if not installed_set[lang] then
					table.insert(missing, lang)
				end
			end
			if #missing > 0 then
				require("nvim-treesitter").install(missing)
			end

			local current_node = nil
			local node_stack = {}

			local function select_node(node)
				local sr, sc, er, ec = node:range()
				vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
				current_node = node
			end

			vim.keymap.set("n", "<C-space>", function()
				local node = vim.treesitter.get_node()
				if not node then
					return
				end
				node_stack = {}
				select_node(node)
			end, { desc = "Incremental treesitter selection" })

			vim.keymap.set("x", "<C-space>", function()
				if not current_node then
					return
				end
				local parent = current_node:parent()
				if not parent then
					return
				end
				table.insert(node_stack, current_node)
				vim.cmd("normal! \27")
				select_node(parent)
			end, { desc = "Expand treesitter selection" })

			vim.keymap.set("x", "<bs>", function()
				local prev = table.remove(node_stack)
				if not prev then
					return
				end
				vim.cmd("normal! \27")
				select_node(prev)
			end, { desc = "Shrink treesitter selection" })
		end,
	},
}
