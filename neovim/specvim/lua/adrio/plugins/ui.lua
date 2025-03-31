return {
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"rcarriga/nvim-notify",
		priority = 900,
		keys = {
			{
				"<leader>nn",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss Current Notification",
			},
		},
		opts = {
			background_colour = "#000012",
			timeout = 3000,
			render = "wrapped-default",
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = false,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = false,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
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
			notifier = { enabled = false, timeout = 3000 },
			quickfile = { enabled = true },
			image = { enabled = true },
			words = { enabled = true },
			input = { enabled = true },
			dashboard = {
				width = 60,
				row = nil, -- dashboard position. nil for center
				col = nil, -- dashboard position. nil for center
				pane_gap = 4, -- empty columns between vertical panes
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
				preset = {
					pick = nil,
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
							action = "<cmd>SessionRestore<CR>",
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
				-- item field formatters
				formats = {
					icon = function(item)
						if item.file and item.icon == "file" or item.icon == "directory" then
							return M.icon(item.file, item.icon)
						end
						return { item.icon, width = 2, hl = "icon" }
					end,
					footer = { "%s", align = "center" },
					header = { "%s", align = "center" },
					file = function(item, ctx)
						local fname = vim.fn.fnamemodify(item.file, ":~")
						fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
						if #fname > ctx.width then
							local dir = vim.fn.fnamemodify(fname, ":h")
							local file = vim.fn.fnamemodify(fname, ":t")
							if dir and file then
								file = file:sub(-(ctx.width - #dir - 2))
								fname = dir .. "/…" .. file
							end
						end
						local dir, file = fname:match("^(.*)/(.+)$")
						return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } }
							or { { fname, hl = "file" } }
					end,
				},
			},
			gitbrowse = {
				notify = true,
				-- what = "permalink",
				-- config = function(opts)
				-- 	table.insert(opts.remote_patterns, { "my", "custom pattern" })
				-- end,
			},
			-- styles = {
			-- 	notification = {
			-- 		wo = { wrap = true, width = 50 }, -- Wrap notifications
			-- 	},
			-- },
		},
		keys = {
			{
				"<leader>q",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>gG",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Git Browse Remote",
			},
			-- {
			-- 	"<leader>gf",
			-- 	function()
			-- 		Snacks.lazygit.log_file()
			-- 	end,
			-- 	desc = "Lazygit Current File History",
			-- },
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
