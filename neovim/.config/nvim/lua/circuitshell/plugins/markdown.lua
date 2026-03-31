-- https://github.com/MeanderingProgrammer/markdown.nvim
--
-- When I hover over markdown headings, this plugins goes away, so I need to
-- edit the default highlights
-- I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so the only way I was able to make it work was loading it
-- after the config.lazy in the init.lua file

return {
	{
		"iamcco/markdown-preview.nvim",
		keys = {
			{
				"<leader>mp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		init = function()
			-- The default filename is 「${name}」and I just hate those symbols
			vim.g.mkdp_page_title = "${name}"
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = true,
		-- Moved highlight creation out of opts as suggested by plugin maintainer
		-- There was no issue, but it was creating unnecessary noise when ran
		-- :checkhealth render-markdown
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
		opts = {
			indent = {
				enabled = true,
				per_level = 2,
				skip_level = 1,
				skip_heading = false,
			},
			bullet = {
				enabled = true,
				left_pad = 2,
				right_pad = 1,
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
			-- Add custom icons
			link = {
				image = "󰥶 ",
				custom = {
					youtu = { pattern = "youtu%.be", icon = "󰗃 " },
				},
			},
			heading = {
				sign = false,
				icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
				backgrounds = {
					"Headline1Bg",
					"Headline2Bg",
					"Headline3Bg",
					"Headline4Bg",
					"Headline5Bg",
					"Headline6Bg",
				},
				foregrounds = {
					"Headline1Fg",
					"Headline2Fg",
					"Headline3Fg",
					"Headline4Fg",
					"Headline5Fg",
					"Headline6Fg",
				},
			},
			code = {
				-- if I'm not using yabai, I cannot make the color of the codeblocks
				-- transparent, so just disabling all rendering 😢
				style = "none",
			},
		},
	},

	-- Inline image rendering using Kitty Graphics Protocol.
	-- Prerequisites: brew install imagemagick
	-- For tmux: set -g allow-passthrough on  in .tmux.conf
	-- For kitty: allow_remote_control yes  in kitty.conf
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
					only_render_image_at_cursor = false,
					filetypes = { "markdown" },
				},
			},
			max_width_window_percentage = 60,
			max_height_window_percentage = 40,
			kitty_method = "normal",
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
		},
	},

	-- Renders mermaid (and other diagram) code blocks inline as images.
	-- Prerequisites: volta run --node 18 npm install -g @mermaid-js/mermaid-cli
	{
		"3rd/diagram.nvim",
		dependencies = { "3rd/image.nvim" },
		ft = { "markdown" },
		config = function()
			require("diagram").setup({
				integrations = {
					require("diagram.integrations.markdown"),
				},
				renderers = {
					mermaid = ("mmdc"),
					plantuml = ("plantuml"),
					d2 = ("d2"),
					gnuplot = ("gnuplot"),
				},
			})
		end,
	},

	-- Paste images from clipboard into markdown.
	-- Usage: copy an image to clipboard, then <leader>pi in a markdown file.
	-- You will be prompted for a filename; the image is saved relative to the
	-- current file (in ./assets/ by default) and a markdown link is inserted.
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
