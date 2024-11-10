return {
	{
		"refractalize/oil-git-status.nvim",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("oil-git-status").setup({
				-- Change these symbols if you want
				symbols = {
					added = "A",
					deleted = "D",
					modified = "M",
					renamed = "R",
					untracked = "?",
					ignored = "I",
					unstaged = "U",
					staged = "S",
					conflict = "C",
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				-- default_file_explorer = "nvim-tree",
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
				},
				win_options = {
					signcolumn = "yes:1",
				},

				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 0,
					max_height = 0,
					border = "rounded",
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

			-- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in current window" })
			vim.keymap.set("n", "-", require("oil").toggle_float)
		end,
	},

	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	dependencies = "nvim-tree/nvim-web-devicons",
	-- 	config = function()
	-- 		local nvimtree = require("nvim-tree")

	-- 		-- recommended settings from nvim-tree documentation
	-- 		vim.g.loaded_netrw = 1
	-- 		vim.g.loaded_netrwPlugin = 1

	-- 		nvimtree.setup({
	-- 			view = {
	-- 				width = 35,
	-- 				relativenumber = true,
	-- 				-- float = {
	-- 				-- 	enable = false,
	-- 				-- 	show_header = false,
	-- 				-- },
	-- 			},
	-- 			-- change folder arrow icons
	-- 			renderer = {
	-- 				indent_markers = {
	-- 					enable = true,
	-- 				},
	-- 				icons = {
	-- 					glyphs = {
	-- 						folder = {
	-- 							arrow_closed = "", -- arrow when folder is closed
	-- 							arrow_open = "", -- arrow when folder is open
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 			-- disable window_picker for
	-- 			-- explorer to work well with
	-- 			-- window splits
	-- 			actions = {
	-- 				open_file = {
	-- 					window_picker = {
	-- 						enable = false,
	-- 					},
	-- 				},
	-- 			},
	-- 			filters = {
	-- 				custom = { ".DS_Store" },
	-- 			},
	-- 			git = {
	-- 				ignore = false,
	-- 			},
	-- 		})

	-- 		-- set keymaps
	-- 		local keymap = vim.keymap -- for conciseness

	-- 		keymap.set(
	-- 			"n",
	-- 			"<leader>ee",
	-- 			"<cmd>NvimTreeFindFileToggle<CR>",
	-- 			{ desc = "Toggle file explorer on current file" }
	-- 		) -- toggle file explorer on current file
	-- 		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
	-- 		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

	-- 		-- Open NvimTree automatically on startup
	-- 		-- vim.cmd([[autocmd VimEnter * NvimTreeOpen]])
	-- 	end,
	-- },
}
