return {
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			user_default_options = {
				names = false, -- disable named colors
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {
			preset = "modern",
			win = { border = "single" },
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			animate = { enabled = true },
			bigfile = { enabled = true },
			explorer = { enabled = true },
			quickfile = { enabled = true },
			image = { enabled = true },
			words = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			dashboard = {
				width = 60,
				row = nil,
				col = nil,
				pane_gap = 4,
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
				preset = {
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
					keys = {
						{
							icon = " ",
							key = "s",
							desc = "Restore Session",
							action = "<cmd>AutoSession restore<CR>",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					header = [[
   circuit-shell's nvim⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⢺⣿⣿⡗⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⣾⣿⣿⣷⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣶⣶⣤⡀⠀⠀⠿⣛⣛⣛⣛⠻⠀⠀⢀⣤⣶⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⠿⣛⣵⠄⠛⠛⣭⢩⡍⣭⠛⠛⠰⣬⣛⠿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⡟⢡⣾⠋⣤⢠⡿⠣⡄⢸⡇⢤⠜⢿⡀⣤⠙⣷⡌⢻⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠿⠟⢁⡿⢡⠶⠶⠛⠃⢴⡆⢸⡇⢴⡦⠘⠓⠶⠶⡌⢿⡈⠻⢿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⠟⠀⠀⣈⠁⡆⢀⡴⠛⠀⣸⣄⢸⡇⣸⣇⠀⠛⢦⠀⢰⠈⣁⠀⠀⠻⣿⣿⣇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⢰⣿⠐⠻⢸⡇⢿⠞⢙⣋⣠⣄⣙⡋⠻⡿⢸⡀⠟⠂⣿⡄⠀⠀⠘⣿⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⡏⠀⠀⠀⢸⣿⢈⣭⣭⣤⠟⣰⣯⠉⠑⠊⠉⣽⣄⠳⣤⣭⣭⡁⣿⡇⠀⠀⠀⢹⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠘⣿⠸⡇⢴⠦⢼⡇⣩⠞⢉⡉⠳⣍⢸⡧⠴⡦⢸⠃⣿⠃⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⡆⠶⢐⡇⠀⡾⠁⡴⠳⠞⢦⠈⣷⠀⢸⡀⠦⢰⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠄⢋⡀⣠⠇⠀⡇⢺⡇⢸⠀⠻⣄⢀⡙⢠⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢶⡌⠁⣇⢀⡴⠃⢸⡇⠘⢦⠀⣸⠈⣡⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣌⢻⣦⠙⢸⡇⣶⠆⢹⣶⢸⡇⠋⣴⠟⣡⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣦⠁⢶⣌⡁⣿⢸⡇⣿⢘⣥⡷⠈⣴⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⡇⠀⠙⠻⣦⣜⣣⣴⠟⠋⠀⢸⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠟⠉⠀⠀⠀⠀⠈⠙⠋⠁⠀⠀⠀⠀⠉⠻⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

]],
				},
			},
			gitbrowse = {
				notify = true,
				config = function(opts)
					-- Ensure url_patterns exists
					opts.url_patterns = opts.url_patterns or {}

					-- Define GitHub domains to add
					local github_domains = {
						"github%.cloud%.com",
						"github%.cloud%.capitalone%.com",
					}

					-- Define GitHub pattern structure
					local github_pattern = {
						branch = "/tree/{branch}",
						file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
						permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
						commit = "/commit/{commit}",
					}

					-- Add patterns for all GitHub Enterprise domains
					for _, domain in ipairs(github_domains) do
						opts.url_patterns[domain] = github_pattern
					end
				end,
			},
		},
		keys = {
			{
				"<leader><leader>",
				":",
				desc = "Command Line",
			},
			{
				"<leader>q",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>gg",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse Remote",
			},
			{
				"<leader>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Lazygit Current File History",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Lazygit Log (cwd)",
			},
			{
				"<leader>rf",
				function()
					Snacks.rename()
				end,
				desc = "Rename File",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next Reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
					Snacks.toggle.diagnostics():map("<leader>td")
					Snacks.toggle.line_number():map("<leader>tl")
					Snacks.toggle.treesitter():map("<leader>tT")
					Snacks.toggle.inlay_hints():map("<leader>th")
				end,
			})
		end,
	},
}
