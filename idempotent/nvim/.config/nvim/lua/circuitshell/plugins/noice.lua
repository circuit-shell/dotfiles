return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			-- Snacks handles vim.notify — noice stays out of it
			notify = { enabled = false },

			-- nvim-cmp owns the completion popupmenu
			popupmenu = { enabled = false },

			-- Floating cmdline (replaces wilder)
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
						pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
						icon = "",
						lang = "lua",
					},
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
				},
			},

			messages = { enabled = true },

			lsp = {
				progress = { enabled = true },
				-- Better markdown in hover/signature docs (safe, no conflict)
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				-- lsp.lua handles hover and signature — noice stays out
				hover = { enabled = false },
				signature = { enabled = false },
			},

			views = {
				cmdline_popup = {
					position = { row = "40%", col = "50%" },
					size = { width = 60, height = "auto" },
					border = { style = "single" },
				},
			},

			routes = {
				-- Suppress "written" messages when saving
				{ filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
				-- Suppress search wrap messages
				{ filter = { event = "msg_show", find = "search hit" }, opts = { skip = true } },
			},
		},
		keys = {
			{ "<leader>nl", function() require("noice").cmd("last") end,    desc = "Last Message" },
			{ "<leader>nh", function() require("noice").cmd("history") end, desc = "Message History" },
			{
				"<S-Enter>",
				function() require("noice").redirect(vim.fn.getcmdline()) end,
				mode = "c",
				desc = "Redirect to Split",
			},
		},
	},
}
