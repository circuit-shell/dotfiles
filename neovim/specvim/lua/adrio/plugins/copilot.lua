return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Disable default Tab mapping
			vim.g.copilot_no_tab_map = true

			-- Set up Ctrl+h mapping to accept the suggestion
			vim.api.nvim_set_keymap(
				"i",
				"<C-l>",
				'copilot#Accept("<CR>")',
				{ silent = true, expr = true, noremap = true }
			)

			-- Optional: Disable Copilot for certain filetypes
			-- vim.g.copilot_filetypes = { xml = false, markdown = false }

			-- Optional: Set up other Copilot options
			-- vim.g.copilot_enabled = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
