return {
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")
			-- Configure statuscol
			require("statuscol").setup({
				relculright = true,
				thousands = false,
				ft_ignore = { "NvimTree", "packer", "dashboard", "oil", "alpha" },
				bt_ignore = { "NvimTree", "packer", "dashboard", "oil", "alpha" },
				segments = {
					-- Git signs
					{
						sign = {
							namespace = {
								"gitsigns",
							},
							maxwidth = 1,
							auto = true,
						},
						click = "v:lua.ScSa",
					},
					-- Enable breakpoints
					{
						sign = {
							name = { "DapBreakpoint", "DapBreakpointCondition", "DapBreakpointRejected" },
							maxwidth = 1,
							auto = true,
						},
						click = "v:lua.ScSa",
					},

					-- Fold segment
					{
						text = { builtin.foldfunc },
						condition = { true },
						click = "v:lua.ScFa",
					},
					-- Absolute line number
					{ text = { "%l " }, auto = true, minwidth = 1 },
					-- Relative line number
					{ text = { "%=%r " }, auto = true, minwidth = 2 },
					-- Diagnostic signs
					{
						sign = { namespace = { "diagnostic/signs" }, width = 2, auto = true, align = "right" },
						click = "v:lua.ScSa",
					},
					{ text = { "│ " }, auto = true, minwidth = 2 },
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
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			"neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
		},
		config = function()
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
			vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
			vim.keymap.set("n", "zs", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Fold/Show Hover" })

			require("ufo").setup({
				close_fold_kinds_for_ft = {
					["lua"] = { "comment" },
				},
				enable_get_fold_virt_text = true,
				open_fold_hl_timeout = 1000,
				provider_selector = function()
					return { "lsp", "indent" }
				end,
				preview = {
					win_config = {
						border = "rounded",
						winhighlight = "Normal:Folded",
						winblend = 0,
					},
					mappings = {
						scrollU = "<C-u>",
						scrollD = "<C-d>",
						jumpTop = "[",
						jumpBot = "]",
					},
				},
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require("neoscroll").setup({
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true,
				stop_eof = false,
				use_local_scrolloff = false,
				respect_scrolloff = false,
				cursor_scrolls_alone = true,
			})
		end,
	},

	-- dependencies = {
	-- 	-- dap deps
	-- 	"mfussenegger/nvim-dap",
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	"rcarriga/nvim-dap-ui",
	-- },
}
