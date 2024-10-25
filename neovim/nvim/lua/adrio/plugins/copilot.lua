return {
	"github/copilot.vim",
	lazy = false,
	config = function()
		-- Disable default Tab mapping
		vim.g.copilot_no_tab_map = true

		-- Set up Ctrl+h mapping to accept the suggestion
		vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

		-- Optional: Disable Copilot for certain filetypes
		-- vim.g.copilot_filetypes = { xml = false, markdown = false }

		-- Optional: Set up other Copilot options
		-- vim.g.copilot_enabled = true
	end,
}
