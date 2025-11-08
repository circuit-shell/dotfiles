return {
	{
		"luukvbaal/statuscol.nvim",
		config = function()
			local builtin = require("statuscol.builtin")

			local function custom_lnum()
				-- Don't show line number for wrapped lines
				if vim.v.virtnum ~= 0 then
					return ""
				end

				local lnum = vim.v.lnum
				local relnum = vim.v.relnum

				-- For the current line, use CursorLineNr highlight
				if relnum == 0 then
					local result = "%#CursorLineNr#" .. lnum
					if vim.wo.relativenumber then
						result = result .. "%=%#CursorLineNr# " .. relnum
					end
					return result
				else
					-- For other lines, use NonText highlight
					local result = "%#NonText#" .. lnum
					if vim.wo.relativenumber then
						result = result .. "%=%#NonText# " .. relnum
					end
					return result
				end
			end

			require("statuscol").setup({
				relculright = true,
				thousands = false,
				ft_ignore = { "NvimTree", "packer", "dashboard", "oil", "alpha" },
				bt_ignore = { "NvimTree", "packer", "dashboard", "oil", "alpha" },
				segments = {
					-- Enable breakpoints
					{
						sign = {
							name = { "DapBreakpoint", "DapBreakpointCondition", "DapBreakpointRejected" },
							width = 1,
						},
						click = "v:lua.ScSa",
					},
					-- Diagnostic signs
					{
						sign = {
							namespace = { "diagnostic" },
							width = 1,
							align = "right",
						},
						click = "v:lua.ScSa",
					},
					-- Git signs
					{
						sign = {
							namespace = {
								"gitsigns",
							},
							maxwidth = 1,
						},
						click = "v:lua.ScSa",
					},
					-- Fold segment
					{
						text = { builtin.foldfunc },
						condition = { true },
						click = "v:lua.ScFa",
					},
					{
						text = { custom_lnum },
						click = "v:lua.ScLa",
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
					["diagnostic"] = builtin.diagnostic_click,
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
