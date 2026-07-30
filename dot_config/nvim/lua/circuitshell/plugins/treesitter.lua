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

			local current_node = nil
			local node_stack = {}

			local function select_node(node)
				local sr, sc, er, ec = node:range()
				vim.cmd("normal! \27")
				vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
				vim.cmd("normal! v")
				vim.api.nvim_win_set_cursor(0, { er + 1, math.max(0, ec - 1) })
				current_node = node
			end

			vim.keymap.set({ "n", "x" }, "<C-space>", function()
				if vim.fn.mode() ~= "n" and current_node then
					local parent = current_node:parent()
					if not parent then
						return
					end
					table.insert(node_stack, current_node)
					select_node(parent)
				else
					local node = vim.treesitter.get_node()
					if not node then
						return
					end
					node_stack = {}
					select_node(node)
				end
			end, { desc = "Incremental treesitter selection" })

			vim.keymap.set("x", "<bs>", function()
				local prev = table.remove(node_stack)
				if not prev then
					return
				end
				select_node(prev)
			end, { desc = "Shrink treesitter selection" })
		end,
	},
}
