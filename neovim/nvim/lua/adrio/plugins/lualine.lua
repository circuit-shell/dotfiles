return {
	"nvim-lualine/lualine.nvim",
	opts = function()
		local lspStatus = {
			function()
				local msg = "No LSP"
				local buf_ft = vim.api.nvim_get_option_value("filetype", {})
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					-- local filetypes = client.config.filetypes
					local filetypes = rawget(client.config, "filetypes") or {}
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = "",
			color = { fg = "#0E1219" },
		}

		local buffer = {
			"buffers",
			mode = 0,
			show_filename_only = true,
			show_modified_status = true,
			hide_filename_extension = false,
			closable = true,
			symbols = { alternate_file = "" },
			filetype_names = {
				["alpha"] = "Welcome Back! 👻👻👻👻👻👻",
				["lazy"] = "Lazy",
				["TelescopePrompt"] = "Telescope",
			},
			buffers_color = {
				active = { fg = "#d3d3d3" },
				inactive = { fg = "#757575" },
			},
			always_divide_middle = true,
		}

		local diagnostic = {
			"diagnostics",
			symbols = {
				error = " ",
				warn = " ",
				info = " ",
				hint = " ",
			},
			update_in_insert = false, -- Update diagnostics in insert mode.
		}

		return {
			options = {
				icons_enabled = true,
				theme = "ayu_mirage",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "dashboard", "lazy" },
				always_divide_middle = true,
				globalstatus = true,
			},
			always_divide_middle = true,
			sections = {},
			tabline = {
				lualine_a = { "mode" },
				lualine_b = { buffer },
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					diagnostic,
				},
				lualine_z = {
					lspStatus,
					{
						"filetype",
						icons_enabled = false,
					},
				},
			},
		}
	end,
}
