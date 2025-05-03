local handle = io.popen("whoami")
local current_user = ""
if handle then
	current_user = handle:read("*a"):gsub("%s+", "")
	handle:close()
end

local lazy_copilot = current_user == "spectr3r-system"

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			vim.notify("Copilot enabled: " .. tostring(lazy_copilot), vim.log.levels.INFO)
		end)
	end,
})

return {
	{
		"github/copilot.vim",
		lazy = lazy_copilot,
		config = function()
			-- Disable default Tab mapping, this helps to be able to use suggestion in copilot chat
			vim.g.copilot_no_tab_map = true

			-- Set up Ctrl+l mapping to accept the suggestion
			vim.api.nvim_set_keymap(
				"i",
				"<C-l>",
				'copilot#Accept("<CR>")',
				{ silent = true, expr = true, noremap = true }
			)

			-- Add toggle function
			vim.api.nvim_create_user_command("ToggleCopilot", function()
				if vim.g.copilot_enabled == 0 then
					vim.cmd("Copilot enable")
					print("Copilot enabled")
				else
					vim.cmd("Copilot disable")
					print("Copilot disabled")
				end
			end, {})

			-- Add leader+uc mapping to toggle Copilot
			vim.api.nvim_set_keymap("n", "<leader>tC", ":ToggleCopilot<CR>", { silent = true, noremap = true })
			-- Add leader leader+lc mapping to toggle Copilot chat
			vim.api.nvim_set_keymap("n", "<leader>tc", ":CopilotChatToggle<CR>", { silent = true, noremap = true })
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = lazy_copilot,
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			selection = function(source)
				local select = require("CopilotChat.select")
				return select.visual(source) or ""
			end,
			model = "gpt-4o",
			context = nil,
			mappings = {
				reset = {
					insert = "",
					normal = "R",
				},
			},
		},
	},
}
