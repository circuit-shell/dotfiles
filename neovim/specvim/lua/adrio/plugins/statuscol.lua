return {
	"luukvbaal/statuscol.nvim",
	config = function()
		-- Enable relative and absolute line numbers
		vim.opt.relativenumber = true
		vim.opt.number = true

		-- Configure statuscol
		require("statuscol").setup({
			relculright = true,
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
				{ text = { "%l " }, click = "v:lua.scra", auto = true, minwidth = 3 },
				-- Relative line number
				{ text = { "%=%r │ " }, click = "v:lua.scla", auto = true, minwidth = 2 },
			},
		})
	end,
}
