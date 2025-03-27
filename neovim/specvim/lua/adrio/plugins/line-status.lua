local colors = {
	peach = "#FFB86C",
	cyan = "#33AFFF",
	black = "#191A21",
	white = "#F8F8F2",
	red = "#FF5555",
	flamingo = "#FF79C6",
	grey = "#21222C",
}

local line_theme = {
	normal = {
		a = { fg = colors.black, bg = colors.flamingo },
		b = { fg = colors.white, bg = colors.grey },
		c = { fg = colors.white },
	},

	insert = { a = { fg = colors.black, bg = colors.peach } },
	visual = { a = { fg = colors.black, bg = colors.cyan } },
	replace = { a = { fg = colors.black, bg = colors.red } },

	inactive = {
		a = { fg = colors.white, bg = colors.black },
		b = { fg = colors.white, bg = colors.black },
		c = { fg = colors.white },
	},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
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
      "alpha"
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

		lualine.setup({
			options = {
				theme = line_theme,
				disabled_filetypes = {
					winbar = excluded_filetypes_array,
				},
				globalstatus = true,
				section_separators = { left = "", right = "" },
				component_separators = { right = "│", left = "│" },
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
						"filename",
						file_status = true,
						color = { fg = "#33afff" },
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
						color = { fg = "#F8F8F2", gui = "bold" },
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
				lualine_y = { -- diagnostics
					{
						"diagnostics",
						update_in_insert = true,
						sources = { "nvim_lsp" },
					},

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
						color = { fg = "#33afff" },
					},
				},
				lualine_z = {
					{ "location", separator = { left = "", right = "" }, right_padding = 2 },
				},
			},
		})
	end,
}
