-- how can change the theme of telescope in my settings file:
return {
	{ "axkirillov/telescope-changed-files" },
	{ "debugloop/telescope-undo.nvim" },
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"aaronhallaert/advanced-git-search.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-fugitive",
			"tpope/vim-rhubarb",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
			"jonarrien/telescope-cmdline.nvim",
			"axkirillov/telescope-changed-files",
			"debugloop/telescope-undo.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local theme_config = {
				theme = "cursor",
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						prompt_position = "top",
						width = { padding = 0.05 },
						mirror = true,
						height = { padding = 0 },
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
								width= 100,
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

			keymap.set("n", "<leader><leader>", "<cmd>Telescope cmdline<cr>", { desc = "cmdline" })

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("undo")
			require("telescope").load_extension("changed_files")
			require("telescope").load_extension("advanced_git_search")
			-- require("telescope").load_extension("colors")
			-- require("telescope").load_extension("noice")
			require("telescope").load_extension("harpoon")
			require("telescope").load_extension("cmdline")
		end,
	},
}
