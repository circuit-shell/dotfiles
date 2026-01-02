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
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
			"axkirillov/telescope-changed-files",
			"aaronhallaert/advanced-git-search.nvim",
			"debugloop/telescope-undo.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local theme_config = {
				theme = "cursor",
				layout_strategy = "vertical",
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				layout_config = {
					vertical = {
						prompt_position = "top",
						width = { padding = 0.05 },
						mirror = true,
						height = { padding = 0.05 },
						preview_height = 0.75,
						scroll_speed = 0.1,
					},
				},
				sorting_strategy = "ascending",
			}
			telescope.setup({
				pickers = {
					find_files = theme_config,
					oldfiles = theme_config,
					live_grep = theme_config,
					grep_string = theme_config,
					buffers = theme_config,
					help_tags = theme_config,
					changed_files = theme_config,
					todo = theme_config,
				},
				extensions = {
					cmdline = {
						-- Adjust telescope picker size and layout
						picker = {
							layout_config = {
								width = 100,
								height = 15,
							},
						},
						-- Adjust your mappings
						mappings = {
							complete = "<Tab>",
							run_selection = "<C-CR>",
							run_input = "<CR>",
						},
						-- Triggers any shell command using overseer.nvim (`:!`)
						overseer = {
							enabled = true,
						},
					},
				},
				defaults = {
					path_display = { "absolute" },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<ScrollWheelUp>"] = function(bufnr)
								require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
								return require("telescope.actions").preview_scrolling_up(bufnr)
							end,
							["<ScrollWheelDown>"] = function(bufnr)
								require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
								return require("telescope.actions").preview_scrolling_down(bufnr)
							end,
						},
						n = {
							["<ScrollWheelUp>"] = function(bufnr)
								require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
								return require("telescope.actions").preview_scrolling_up(bufnr)
							end,
							["<ScrollWheelDown>"] = function(bufnr)
								require("telescope.state").get_status(bufnr).picker.layout_config.scroll_speed = 1
								return require("telescope.actions").preview_scrolling_down(bufnr)
							end,
						},
					},
					border = true,
				},
			})

			telescope.load_extension("fzf")

			local keymap = vim.keymap

			keymap.set("n", "<C-p>", "<cmd>Telescope find_files <cr>", { desc = "find files in cwd" })
			keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
			keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
			keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
			keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor " })
			keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Fuzzy find buffers" })
			keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Fuzzy find help tags" })
			keymap.set("n", "<leader>fg", "<cmd>Telescope changed_files<cr>", { desc = "Fuzzy find git files" })
			keymap.set("n", "<leader>ft", "<cmd>TodoTelescope <cr>", { desc = "Find todos" })
			-- keymap.set("n", "<leader>tm", "<cmd>Telescope noice<cr>", { desc = "Fuzzy find messages" })

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("undo")
			require("telescope").load_extension("changed_files")
			require("telescope").load_extension("advanced_git_search")
			-- require("telescope").load_extension("noice")
		end,
	},
}
