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

			indent = {
				enabled = true,
				per_level = 2,
				skip_level = 1,
				skip_heading = false,
			},

			checkbox = {
				-- Turn on / off checkbox state rendering
				enabled = true,
				-- Determines how icons fill the available space:
				--  inline:  underlying text is concealed resulting in a left aligned icon
				--  overlay: result is left padded with spaces to hide any additional text
				position = "inline",
				unchecked = {
					-- Replaces '[ ]' of 'task_list_marker_unchecked'
					icon = "   󰄱 ",
					-- Highlight for the unchecked icon
					highlight = "RenderMarkdownUnchecked",
					-- Highlight for item associated with unchecked checkbox
					scope_highlight = nil,
				},
				checked = {
					-- Replaces '[x]' of 'task_list_marker_checked'
					icon = "   󰱒 ",
					-- Highlight for the checked icon
					highlight = "RenderMarkdownChecked",
					-- Highlight for item associated with checked checkbox
					scope_highlight = nil,
				},
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
					filetypes = { "markdown" },
				},
			},
			max_width_window_percentage = 60,
			max_height_window_percentage = 40,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
		},
	},

	{
		"3rd/diagram.nvim",
		dependencies = {
			"3rd/image.nvim",
		},
		opts = {
			-- Disable automatic rendering for manual-only workflow
			events = {
				render_buffer = {}, -- Empty = no automatic rendering
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					theme = "dark",
					scale = 2,
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
				ft = { "markdown", "norg" }, -- Only in these filetypes
				desc = "Show diagram in new tab",
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
