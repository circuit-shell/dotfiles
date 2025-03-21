return {
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Disable default Tab mapping
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
			vim.api.nvim_set_keymap("n", "<leader>uc", ":ToggleCopilot<CR>", { silent = true, noremap = true })
			-- Add leader leader+lc mapping to toggle Copilot chat
			vim.api.nvim_set_keymap("n", "<leader>lc", ":CopilotChatToggle<CR>", { silent = true, noremap = true })
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			model = "gpt-4o-2024-11-20",
			mappings = {

        reset = {
          insert = "",
          normal = "C-R"

        }

        ,


      },
		},
	},
}
