return {
	{
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreview<cr>", ft = "markdown", desc = "Markdown Preview" },
			{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", ft = "markdown", desc = "Markdown Preview Stop" },
			{ "<leader>mr", "<cmd>MarkdownPreviewRefresh<cr>", ft = "markdown", desc = "Markdown Preview Refresh" },
		},
		config = function()
			require("markdown_preview").setup({
				instance_mode = "takeover",
				open_browser = true,
				debounce_ms = 300,
				scroll_sync = true,
			})
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
		ft = { "markdown" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			render_modes = { "n", "c", "t" },

			-- No heading glyphs: avoids nvim-ufo fold lines showing icon + visible `#` together.
			heading = {
				icons = function()
					return nil
				end,
			},

			indent = {
				enabled = true,
				per_level = 2,
				skip_level = 1,
				skip_heading = false,
			},

			-- Plain `-` / `+` / `*` markers (no bullet icons), like headings.
			bullet = {
				enabled = false,
			},

			-- Plain `[ ]` / `[x]` text (no checkbox icons).
			checkbox = {
				enabled = false,
			},
			html = {
				-- Turn on / off all HTML rendering
				enabled = true,
				comment = {
					-- Turn on / off HTML comment concealing
					conceal = false,
				},
			},
		},
		keys = {
			{
				"<leader>cy",
				ft = "markdown",
				function()
					local node = vim.treesitter.get_node()
					while node do
						if node:type() == "fenced_code_block" then
							for i = 0, node:named_child_count() - 1 do
								local child = node:named_child(i)
								if child and child:type() == "code_fence_content" then
									local sr, _, er, _ = child:range()
									local lines = vim.api.nvim_buf_get_lines(0, sr, er, false)
									vim.fn.setreg("+", table.concat(lines, "\n"))
									vim.notify("Code block copied!", vim.log.levels.INFO)
									return
								end
							end
						end
						node = node:parent()
					end
					vim.notify("No code block under cursor", vim.log.levels.WARN)
				end,
				desc = "Copy code block",
			},
		},
	},

	{
		"3rd/image.nvim",
		build = false,
		ft = { "markdown" },
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = true,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					only_render_image_at_cursor_mode = "inline",
					filetypes = { "markdown" },
				},
			},
			max_width_window_percentage = 85,
			max_height_window_percentage = 65,
			-- Reduces “stuck” Kitty graphics when splits / floats overlap (see image.nvim README).
			window_overlap_clear_enabled = true,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
		},
	},

	{
		"3rd/diagram.nvim",
		ft = { "markdown", "norg" },
		dependencies = {
			"3rd/image.nvim",
		},
		-- diagram.nvim hover tab used y=5 with only 5 buffer lines → image.nvim E966 (invalid line 6).
		init = function()
			package.preload["diagram/hover"] = function()
				return require("circuitshell.patches.diagram_hover")
			end
		end,
		opts = {
			-- Manual-only: auto render_buffer + Kitty often leaves orphan images (upstream recommends this).
			events = {
				render_buffer = {},
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					-- mmdc -t: default | dark | forest | neutral (see `mmdc --help`)
					theme = "forest",
					-- Optional background: "transparent", "white", or "#rrggbb"
					-- background = "transparent",
					scale = 3,
				},
			},
		},
		keys = {
			{
				"<leader>md",
				function()
					require("diagram").show_diagram_hover()
				end,
				mode = "n",
				ft = { "markdown", "norg" },
				desc = "Mermaid/diagram preview (new tab)",
			},
			{
				"<leader>mX",
				function()
					require("diagram").clear()
					local buf = vim.api.nvim_get_current_buf()
					local ok, image_api = pcall(require, "image")
					if ok then
						for _, img in ipairs(image_api.get_images({ buffer = buf })) do
							img:clear()
						end
					end
				end,
				mode = "n",
				ft = { "markdown", "norg" },
				desc = "Clear stuck diagram + markdown images (buffer)",
			},
		},
	},
	{
		"HakonHarnes/img-clip.nvim",
		ft = { "markdown" },
		opts = {
			default = {
				dir_path = "assets",
				relative_to_current_file = true,
				prompt_for_file_name = true,
				show_dir_path_in_prompt = true,
				use_absolute_path = false,
				insert_mode_after_paste = false,
			},
			filetypes = {
				markdown = {
					url_encode_path = true,
					template = "![$CURSOR]($FILE_PATH)",
					drag_and_drop = {
						enabled = true,
					},
				},
			},
		},
		keys = {
			{ "<leader>pi", "<cmd>PasteImage<cr>", desc = "Paste Image", ft = "markdown" },
		},
	},
}
