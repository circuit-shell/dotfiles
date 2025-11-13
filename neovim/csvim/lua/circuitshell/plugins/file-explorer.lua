return {
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = true,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				columns = { "icon" },
				cleanup_delay_ms = 2000,
				lsp_file_methods = {
					-- Enable or disable LSP file operations
					enabled = true,
					-- Time to wait for LSP file operations to complete before skipping
					timeout_ms = 1000,
					-- Set to true to autosave buffers that are updated with LSP willRenameFiles
					-- Set to "unmodified" to only save unmodified buffers
					autosave_changes = false,
				},
				case_insensitive = false,
				view_options = {
					show_hidden = true,
					show_ignored = true,
					is_always_hidden = function(name, bufnr)
						return vim.fn.match(name, [[\.DS_Store$]]) ~= -1
					end,
				},
				win_options = {
					wrap = true,
					signcolumn = "yes:1",
				},
				keymaps = {
					["<leader>?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<2-LeftMouse>"] = "actions.select",
					["<C-v>"] = {
						"actions.select",
						opts = { vertical = true },
						desc = "Open the entry in a vertical split",
					},
					["<C-h>"] = {
						"actions.select",
						opts = { horizontal = true },
						desc = "Open the entry in a horizontal split",
					},
					["q"] = {
						desc = "Quit Oil",
						"actions.close",
					},
					["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = {
						"actions.cd",
						opts = { scope = "tab" },
						desc = ":tcd to the current oil directory",
						mode = "n",
					},
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				use_default_keymaps = false,
				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 0,
					max_height = 0,
					border = "single",
					win_options = {
						winblend = 0,
					},
					-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
					get_win_title = nil,
					-- preview_split: Split direction: "auto", "left", "right", "above", "below".
					preview_split = "auto",
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					override = function(conf)
						return conf
					end,
				},
			})

			vim.keymap.set("n", "-", require("oil").toggle_float)
			-- add a keymap to toggle the file explorer
			-- vim.keymap.nnoremap("<leader>o", require("oil").toggle)
			-- add a keymap to toggle
		end,
	},
}
