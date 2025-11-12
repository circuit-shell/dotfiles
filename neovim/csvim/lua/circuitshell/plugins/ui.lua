return {
	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- COLOR AND UI ENHANCEMENTS
	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	-- Colorizer: Highlights color codes (#fff, rgb(), etc.) with their actual colors
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre", -- Load when reading a buffer
		opts = {
			user_default_options = {
				names = false, -- Disable named colors like "red", "blue"
			},
		},
	},

	-- Volt: Color picker utility (lazy loaded)
	{ "nvzone/volt", lazy = true },

	-- Minty: Color shade and hue picker
	{ "nvzone/minty", cmd = { "Shades", "Huefy" } },

	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- KEY BINDINGS HELPER
	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	-- Which-key: Displays popup with available keybindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500 -- Delay before which-key popup appears (ms)
		end,
		opts = {
			preset = "modern", -- Modern UI preset
			win = { border = "single" }, -- Single line border around popup
		},
	},

	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- SNACKS.NVIM - Swiss Army Knife Plugin Collection
	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	{
		"folke/snacks.nvim",
		priority = 1000, -- Load early
		lazy = false, -- Always load this plugin
		opts = {
			-- Smooth scrolling and animations
			animate = { enabled = true },

			-- Performance optimization for large files
			bigfile = { enabled = true },

			-- File explorer integration
			explorer = { enabled = true },

			-- Fast file opening
			quickfile = { enabled = true },

			-- Image preview support
			image = { enabled = true },

			-- Highlight word under cursor throughout buffer
			words = { enabled = true },

			-- Enhanced input UI
			input = { enabled = true },

			-- Notification system
			notifier = { enabled = true },

			-- ─────────────────────────────────────────────────────────────────
			-- Dashboard Configuration
			-- ─────────────────────────────────────────────────────────────────
			dashboard = {
				width = 60,
				row = nil, -- Center vertically
				col = nil, -- Center horizontally
				pane_gap = 4, -- Gap between panes
				autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
				preset = {
					sections = {
						{ section = "header" },
						{ section = "keys", gap = 1, padding = 1 },
						{ section = "startup" },
					},
					-- Dashboard action keys
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
					-- ASCII art header
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

			-- ─────────────────────────────────────────────────────────────────
			-- Git Browse Configuration (for GitHub Enterprise support)
			-- ─────────────────────────────────────────────────────────────────
			gitbrowse = {
				notify = true, -- Show notifications when opening URLs
				config = function(opts)
					-- Initialize url_patterns table if it doesn't exist
					opts.url_patterns = opts.url_patterns or {}

					-- GitHub Enterprise domain patterns to support
					local github_domains = {
						"github%.cloud%.com",
						"github%.cloud%.capitalone%.com",
					}

					-- URL pattern structure for GitHub-style repos
					local github_pattern = {
						branch = "/tree/{branch}",
						file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
						permalink = "/blob/{commit}/{file}#L{line_start}-L{line_end}",
						commit = "/commit/{commit}",
					}

					-- Register patterns for all GitHub Enterprise domains
					for _, domain in ipairs(github_domains) do
						opts.url_patterns[domain] = github_pattern
					end
				end,
			},
		},

		-- ─────────────────────────────────────────────────────────────────
		-- Key Mappings for Snacks.nvim
		-- ─────────────────────────────────────────────────────────────────
		keys = {
			-- Quick access to command line
			{
				"<leader><leader>",
				":",
				desc = "Command Line",
			},
			-- Buffer management
			{
				"<leader>q",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			-- Git integration
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
			-- File operations
			{
				"<leader>rf",
				function()
					Snacks.rename()
				end,
				desc = "Rename File",
			},
			-- Word reference navigation
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

		-- ─────────────────────────────────────────────────────────────────
		-- Snacks.nvim Initialization
		-- ─────────────────────────────────────────────────────────────────
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup debugging globals (lazy-loaded for performance)
					_G.dd = function(...)
						Snacks.debug.inspect(...) -- Pretty print objects
					end
					_G.bt = function()
						Snacks.debug.backtrace() -- Print stack trace
					end

					-- Override print to use snacks for `:=` command
					vim.print = _G.dd

					-- Register toggle keymaps for common options
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

	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	-- COLOR SCHEME - CATPPUCCIN (CUSTOM DRACULA COLORS)
	-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load before other plugins for proper highlighting
		config = function()
			require("catppuccin").setup({
				-- Flavor selection based on background
				background = {
					light = "latte",
					dark = "mocha",
				},

				-- Visual settings
				transparent_background = true, -- Transparent background
				show_end_of_buffer = false, -- Hide ~ characters at end of buffer
				term_colors = false, -- Don't set terminal colors

				-- Inactive window styling
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},

				-- Font style toggles
				no_italic = false,
				no_bold = false,
				no_underline = false,

				-- Syntax element styles
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},

				-- Custom Dracula-inspired color palette
				color_overrides = {
					all = {
						rosewater = "#FFB86C",
						flamingo = "#FF79C6",
						pink = "#FF79C6",
						mauve = "#BD93F9",
						red = "#FF5555",
						maroon = "#FF5555",
						peach = "#FFB86C",
						yellow = "#F1FA8C",
						green = "#81fba0",
						teal = "#33AFFF",
						sky = "#33AFFF",
						sapphire = "#33AFFF",
						blue = "#BD93F9",
						lavender = "#FF79C6",
						text = "#F8F8F2",
						subtext1 = "#F8F8F2",
						subtext0 = "#BFBFBF",
						overlay2 = "#6c7086",
						overlay1 = "#7970A9",
						overlay0 = "#6272A4",
						surface2 = "#414458",
						surface1 = "#343746",
						surface0 = "#282A36",
						base = "#1C1E26", -- Darker base background
						mantle = "#111110", -- Darker mantle
						crust = "#0F1014", -- Darker crust
					},
				},

				-- Custom highlight overrides
				custom_highlights = {
					-- Punctuation and delimiters
					["@punctuation.delimiter"] = { fg = "#F8F8F2" },
					["Delimiter"] = { fg = "#F8F8F2" },

					-- Diagnostics
					["DiagnosticUnnecessary"] = { fg = "#FF5555" },

					-- DAP (Debug Adapter Protocol) highlights
					["DapBreakpoint"] = { fg = "#FF5555" }, -- Red breakpoint
					["DapStopped"] = { fg = "#FFB86C" }, -- Orange stopped line
					["DapStoppedLine"] = { bg = "#493B30" }, -- Highlight stopped line bg
					["DapBreakpointRejected"] = { fg = "#848484" }, -- Gray rejected breakpoint
					["DapLogPoint"] = { fg = "#33AFFF" }, -- Blue log point
					["DapBreakpointCondition"] = { fg = "#E51400" }, -- Dark red conditional
				},

				-- Plugin integrations
				integrations = {
					cmp = true, -- nvim-cmp completion
					gitsigns = true, -- Git signs in gutter
					nvimtree = true, -- File tree
					treesitter = true, -- Syntax highlighting
					notify = true, -- Notification plugin
					mini = {
						enabled = true,
						indentscope_color = "", -- Use default color for indent scope
					},
				},
			})

			-- Apply the colorscheme
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
