return {
	"luukvbaal/statuscol.nvim",
	config = function()
		-- Enable relative and absolute line numbers
		vim.opt.relativenumber = true
		vim.opt.number = true

		-- Add folding settings
		vim.opt.foldmethod = "syntax"
		vim.opt.foldlevel = 99 -- Start with all folds open
		vim.opt.foldenable = true -- Enable folding
		vim.opt.foldcolumn = "1" -- Show fold column

		-- Set fillchars
		vim.opt.fillchars = {
			fold = "·", -- Show dots for folded lines
			foldclose = "", -- Symbol for open folds
			foldopen = "", -- Symbol for closed folds
			foldsep = " ", -- Symbol for fold separator
			diff = "╱", -- Used for diff
			eob = " ", -- Empty lines at the end of buffer
			horiz = "━", -- Horizontal split separator
			horizup = "┻", -- Horizontal split separator with up
			horizdown = "┳", -- Horizontal split separator with down
			vert = "┃", -- Vertical split separator
			vertleft = "┫", -- Vertical split separator with left
			vertright = "┣", -- Vertical split separator with right
			verthoriz = "╋", -- Vertical and horizontal split separator
		}

		local builtin = require("statuscol.builtin")

		-- Configure statuscol
		require("statuscol").setup({
			relculright = true,
			thousands = false,
			ft_ignore = { "NvimTree" },
			segments = {
				-- Diagnostic signs
				{
					sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
				-- Fold segment
				{
					text = { builtin.foldfunc },
					condition = { true },
					click = "v:lua.ScFa",
				},
				-- Absolute line number
				{ text = { "%l " }, click = "v:lua.ScFa", auto = true, minwidth = 3 },
				-- Relative line number
				{ text = { "%=%r " }, click = "v:lua.ScFa", auto = true, minwidth = 2 },

				{
					sign = { namespace = { "gitsigns" }, maxwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
			},
			clickmod = "c",
			clickhandlers = {
				Lnum = builtin.lnum_click,
				FoldClose = builtin.foldclose_click,
				FoldOpen = builtin.foldopen_click,
				FoldOther = builtin.foldother_click,
				DapBreakpointRejected = builtin.toggle_breakpoint,
				DapBreakpoint = builtin.toggle_breakpoint,
				DapBreakpointCondition = builtin.toggle_breakpoint,
				["diagnostic/signs"] = builtin.diagnostic_click,
				gitsigns = builtin.gitsigns_click,
			},
		})
	end,
}
