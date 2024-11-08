return {
	"luukvbaal/statuscol.nvim",
	config = function()
		-- Enable relative and absolute line numbers
		vim.opt.relativenumber = true
		vim.opt.number = true
		local builtin = require("statuscol.builtin")

		-- Configure statuscol
		require("statuscol").setup({
			relculright = true,
			thousands = false, -- or line number thousands separator string ("." / ",")
			ft_ignore = { "NvimTree" },
			segments = {
				-- Diagnostic signs
				{
					sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
				-- Git signs
				{
					sign = { namespace = { "gitsigns" }, maxwidth = 2, auto = true },
					click = "v:lua.ScSa",
				},
				-- Absolute line number
				{ text = { "%l " }, click = "v:lua.ScFa", auto = true, minwidth = 3 },
				-- Relative line number
				{ text = { "%=%r │ " }, click = "v:lua.ScSa", auto = true, minwidth = 2 },
			},
			clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
			-- "a" for Alt, "c" for Ctrl and "m" for Meta.
			clickhandlers = { -- builtin click handlers, keys are pattern matched
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
