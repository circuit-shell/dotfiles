local excluded_filetypes = { "NvimTree", "packer", "dashboard", "oil", "alpha", "snacks_dashboard" }

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
				ft_ignore = excluded_filetypes,
				bt_ignore = excluded_filetypes,
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
			--- Leading inline virtual text from render-markdown at column 0 (section indent,
			--- heading margin, etc.). nvim-ufo's captureVirtText often omits col-0 inline marks
			--- (0-based col vs 1-based loop index), which shifts heading icons left when folded.
			---@param bufnr integer
			---@param lnum integer 1-based
			---@return string
			local function render_markdown_leading_fold_padding(bufnr, lnum)
				local ns_id = vim.api.nvim_get_namespaces()["render-markdown.nvim"]
				if not ns_id then
					return ""
				end
				local row = lnum - 1
				local ok, marks = pcall(vim.api.nvim_buf_get_extmarks, bufnr, ns_id, { row, 0 }, { row, -1 }, {
					details = true,
				})
				if not ok or not marks then
					return ""
				end
				local at_col0 = {}
				for _, m in ipairs(marks) do
					local d = m[4]
					if m[2] == row and m[3] == 0 and d.virt_text and d.virt_text_pos == "inline" then
						at_col0[#at_col0 + 1] = m
					end
				end
				table.sort(at_col0, function(a, b)
					return (a[4].priority or 4096) < (b[4].priority or 4096)
				end)
				local w = 0
				for _, m in ipairs(at_col0) do
					local vt = m[4].virt_text
					local skip_icon = false
					if #vt == 1 then
						local t = vt[1][1]
						if not t:find("^%s*$") and vim.fn.strdisplaywidth(t) <= 4 then
							skip_icon = true
						end
					end
					if not skip_icon then
						for _, chunk in ipairs(vt) do
							w = w + vim.fn.strdisplaywidth(chunk[1])
						end
					end
				end
				if w == 0 then
					return ""
				end
				return string.rep(" ", w)
			end

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

			-- Set folding options (required for nvim-ufo)
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.api.nvim_set_hl(0, "UfoFoldSuffix", { fg = "#989898" })

			require("ufo").setup({
				fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
					local bufnr = (ctx and ctx.bufnr) or 0
					local newVirtText = {}
					local sep = ""
					local suffix = (" 󰁂 %d "):format(endLnum - lnum)
					local sufWidth = vim.fn.strdisplaywidth(sep) + vim.fn.strdisplaywidth(suffix)
					local targetWidth = width - sufWidth
					local curWidth = 0

					local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ""

					local padding = ""
					if vim.bo[bufnr].filetype == "markdown" then
						padding = render_markdown_leading_fold_padding(bufnr, lnum)
					end
					if padding == "" then
						local hashes = line:match("^(#+)")
						local level = hashes and #hashes or 0
						padding = level > 1 and string.rep(" ", (level - 1) * 2) or ""
					end
					if padding == "" then
						padding = line:match("^%s+") or ""
					end

					table.insert(newVirtText, { padding, "RenderMarkdownIndent" })
					curWidth = vim.fn.strdisplaywidth(padding)

					for _, chunk in ipairs(virtText) do
						local chunkText = chunk[1]
						local chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if targetWidth > curWidth + chunkWidth then
							table.insert(newVirtText, chunk)
							curWidth = curWidth + chunkWidth
						else
							chunkText = truncate(chunkText, targetWidth - curWidth)
							table.insert(newVirtText, { chunkText, chunk[2] })
							break
						end
					end
					table.insert(newVirtText, { sep, "UfoFoldSuffixSep" })
					table.insert(newVirtText, { suffix, "UfoFoldSuffix" })
					return newVirtText
				end,
				close_fold_kinds_for_ft = {
					["lua"] = { "comment" },
				},
				enable_get_fold_virt_text = true,
				open_fold_hl_timeout = 1000,
				provider_selector = function(bufnr, filetype, buftype)
					-- Use treesitter for markdown files to fold headings
					if filetype == "markdown" then
						return { "treesitter", "indent" }
					end

					if vim.tbl_contains(excluded_filetypes, filetype) then
						return ""
					end

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
	-- dependencies = {
	-- 	-- dap deps
	-- 	"mfussenegger/nvim-dap",
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	"rcarriga/nvim-dap-ui",
	-- },
}
