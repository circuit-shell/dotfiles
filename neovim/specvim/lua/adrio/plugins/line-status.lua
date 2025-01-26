return {
	"nvim-lualine/lualine.nvim", -- Neovim status line
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"SmiteshP/nvim-navic",
		"onsails/lspkind-nvim",
	},
	lazy = false,
	priority = 999,
	config = function()
		local excluded_filetypes_array = {
			"lsp-installer",
			"lspinfo",
			"Outline",
			"lazy",
			"help",
			"packer",
			"netrw",
			"qf",
			"dbui",
			"Trouble",
			"fugitive",
			"floaterm",
			"spectre_panel",
			"spectre_panel_write",
			"checkhealth",
			"man",
			"dap-repl",
			"toggleterm",
			"neo-tree",
			"ImportManager",
			"aerial",
			"oil",
		}
		local excluded_filetypes_table = {}
		for _, value in ipairs(excluded_filetypes_array) do
			excluded_filetypes_table[value] = 1
		end

		vim.cmd("highlight! link StatusLine Normal")
		vim.cmd("highlight! link StatusLineNC Normal")

		local lualine = require("lualine")
		local nvim_navic = require("nvim-navic")
		nvim_navic.setup({
			seperator = "",
			highlight = true,
		})
		local get_buf_filetype = function()
			return vim.api.nvim_buf_get_option(0, "filetype")
		end
		local format_name = function(output)
			if excluded_filetypes_table[get_buf_filetype()] then
				return ""
			end
			return output
		end
		local branch_max_width = 40
		local branch_min_width = 10

		local custom_gruvbox = require("lualine.themes.ayu_dark")
		-- Change the background of lualine_c section for normal mode
		custom_gruvbox.normal.c.bg = "#112233"

		lualine.setup({
			options = {
				theme = "ayu_dark",
				disabled_filetypes = {
					winbar = excluded_filetypes_array,
				},
				globalstatus = true,
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
					{
						"branch",
						fmt = function(output)
							local win_width = vim.o.columns
							local max = branch_max_width
							if win_width * 0.25 < max then
								max = math.floor(win_width * 0.25)
							end
							if max < branch_min_width then
								max = branch_min_width
							end
							if max % 2 ~= 0 then
								max = max + 1
							end
							if output:len() >= max then
								return output:sub(1, (max / 2) - 1) .. "..." .. output:sub(-1 * ((max / 2) - 1), -1)
							end
							return output
						end,
					},
				},
				lualine_b = {
					{
						"diagnostics",
						update_in_insert = true,
						sources = { "nvim_lsp" },
					},
					{
						"filename",
						file_status = false,
						path = 1,
						fmt = format_name,
					},
				},
				lualine_c = {
					-- macros status
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg ~= "" then
								return " REC @" .. reg
							end
							return ""
						end,
						color = { fg = "#86ABDC", gui = "bold" },
					},
				},
				lualine_x = {
					-- number of lines in V mode
					{
						function()
							local start_line = vim.fn.line("v")
							local end_line = vim.fn.line(".")
							local count = math.abs(end_line - start_line) + 1
							return "V(" .. tostring(count) .. ")"
						end,
						cond = function()
							return vim.fn.mode():match("[Vv]") ~= nil
						end,
					},
				},
				lualine_y = {
					-- lsp info
					{
						function()
							local lsps = vim.lsp.get_clients({ bufnr = vim.fn.bufnr() })
							local icon = require("nvim-web-devicons").get_icon_by_filetype(
								vim.api.nvim_buf_get_option(0, "filetype")
							)
							if lsps and #lsps > 0 then
								local names = {}
								for _, lsp in ipairs(lsps) do
									table.insert(names, lsp.name)
								end
								return string.format("%s %s", table.concat(names, ", "), icon)
							else
								return icon or ""
							end
						end,
						on_click = function()
							vim.api.nvim_command("LspInfo")
						end,
						color = function()
							local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(
								vim.api.nvim_buf_get_option(0, "filetype")
							)
							return { fg = color }
						end,
					},
				},
				lualine_z = {
					{ "location", separator = { left = "", right = "" }, right_padding = 2 },
					{ "encoding", separator = { right = "" }, right_padding = 2 },
				},
			},
		})
	end,
}
