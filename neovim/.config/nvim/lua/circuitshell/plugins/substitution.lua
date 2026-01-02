return {
	{ "tpope/vim-repeat" },
	{
		"gbprod/substitute.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local substitute = require("substitute")
			substitute.setup({
				default_file_explorer = true,
			})
			local keymap = vim.keymap
			keymap.set("n", "so", substitute.operator, { desc = "Substitute with motion" })
			keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
			keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
			keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
		end,
	},

	{
		"nvim-mini/mini.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- import mini comment plugin safely
			local comment = require("mini.comment")

			-- enable comment
			comment.setup({
				---Add a space b/w comment and the line
				options = {
					custom_commentstring = nil,
				},
				-- Keymaps
				mappings = {
					-- Line-comment toggle keymap
					comment = "gc",
					-- Block-comment toggle keymap
					comment_line = "gcc",
					-- Uncomment
					uncomment = "gc",
					-- Uncomment line
					uncomment_line = "gcc",
				},
			})
		end,
	},
	{
		"nvim-mini/mini.surround",
		opts = {
			mappings = {
				add = "sa",
				delete = "sd",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
			},
		},
	},
	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter",
		config = function()
			local pairs = require("mini.pairs")
			pairs.setup({
				-- Autopair behavior
				modes = { insert = true, command = false, terminal = false },
				-- Skip autopair when next character is one of these
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				-- Skip autopair when the cursor is inside these treesitter nodes
				skip_ts = { "string" },
				-- Skip autopair when next character is closing pair
				skip_unbalanced = true,
				-- Better deal with markdown code blocks
				markdown = true,
			})
		end,
	},
}
