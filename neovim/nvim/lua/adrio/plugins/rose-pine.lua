return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			extend_background_behind_borders = true,
			styles = {
				bold = true,
				italic = true,
				transparency = true,
			},
			groups = {
				border = "muted",
				link = "iris",
				panel = "surface",

				error = "love",
				hint = "iris",
				info = "foam",
				note = "pine",
				todo = "rose",
				warn = "gold",

				git_add = "foam",
				git_change = "rose",
				git_delete = "love",
				git_dirty = "rose",
				git_ignore = "muted",
				git_merge = "iris",
				git_rename = "pine",
				git_stage = "iris",
				git_text = "rose",
				git_untracked = "subtle",

				h1 = "iris",
				h2 = "foam",
				h3 = "rose",
				h4 = "gold",
				h5 = "pine",
				h6 = "foam",
			},
			highlight_groups = {
				EndOfBuffer = { fg = "surface", bg = "none" },

				TelescopeBorder = { fg = "highlight_high", bg = "none" },
				TelescopeNormal = { bg = "none" },

				TelescopePreviewBorder = { fg = "highlight_high", bg = "none" },
				TelescopePreviewNormal = { bg = "none" },
				TelescopePreviewTitle = { fg = "text", bg = "none", bold = true },

				TelescopeResultsNormal = { fg = "subtle", bg = "none" },
				TelescopeMatching = { fg = "gold" },

				TelescopeSelectionCaret = { fg = "rose", bg = "none" },
				TelescopeSelection = { fg = "pine", bg = "none" },

				Cursor = { fg = "pine", bg = "gold" },
				lCursor = { fg = "pine", bg = "gold" },
			},
		})
		-- vim.cmd("colorscheme rose-pine")
	end,
}
