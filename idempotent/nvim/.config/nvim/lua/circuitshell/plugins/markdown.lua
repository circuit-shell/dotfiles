return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
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

			bullet = {
				enabled = false,
			},

			checkbox = {
				enabled = false,
			},

			html = {
				enabled = true,
				comment = {
					conceal = false,
				},
			},
		},
	},

	{
		"selimacerbas/markdown-preview.nvim",
		dependencies = { "selimacerbas/live-server.nvim" },
		ft = { "markdown" },
		keys = {
			{ "<leader>ml", "<cmd>MarkdownPreview<cr>", ft = "markdown", desc = "Markdown live preview" },
			{ "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", ft = "markdown", desc = "Markdown preview stop" },
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
		"HakonHarnes/img-clip.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
			{
				"<leader>md",
				function()
					require("circuitshell.markdown_simple").open_mermaid_in_viewer()
				end,
				ft = "markdown",
				desc = "Open mermaid block in system viewer (mmdc → SVG)",
			},
			{
				"<leader>mi",
				function()
					require("circuitshell.markdown_simple").open_markdown_image_in_viewer()
				end,
				ft = "markdown",
				desc = "Open markdown image in system viewer",
			},
			{
				"<leader>mp",
				"<cmd>PasteImage<cr>",
				ft = "markdown",
				desc = "Paste clipboard image as markdown link",
			},
			{
				"<leader>mc",
				function()
					require("circuitshell.markdown_simple").copy_fenced_code_block()
				end,
				ft = "markdown",
				desc = "Copy fenced code block",
			},
		},
	},
}
