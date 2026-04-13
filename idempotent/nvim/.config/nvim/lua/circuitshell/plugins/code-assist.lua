local copilot_enabled = vim.env.NVIM_COPILOT ~= "0"
local claude_enabled = vim.env.NVIM_CLAUDE ~= "0"

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			local lines = {
				"  " .. (copilot_enabled and "● Copilot:     enabled" or "○ Copilot:     disabled"),
				"  " .. (claude_enabled and "● Claude Code: enabled" or "○ Claude Code: disabled"),
			}
			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "AI Features" })
		end)
	end,
})

return {
	{
		"github/copilot.vim",
		enabled = copilot_enabled,
		event = "InsertEnter",
		cmd = "Copilot",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-word)", { silent = true })
			vim.cmd("Copilot")
		end,
	},
	{
		"coder/claudecode.nvim",
		enabled = claude_enabled,
		dependencies = { "folke/snacks.nvim" },
		opts = {
			diff_opts = {
				layout = "vertical", -- "vertical" or "horizontal"
				open_in_new_tab = true,
				keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
				hide_terminal_in_new_tab = false,
			},
			terminal = {
				---@module "snacks"
				---@type snacks.win.Config|{}
				snacks_win_opts = {
					position = "float",
					width = 0.8,
					height = 0.8,
					border = "double",
					backdrop = 70,
					keys = {
						claude_hide = {
							"<C-q>",
							function(self)
								self:hide()
							end,
							mode = "t",
							desc = "Hide",
						},
					},
				},
			},
		},
		keys = {
			{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code", mode = { "n", "x" } },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd<cr>", desc = "Add Buffer to Claude" },
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Diff" },
			{ "<leader>cC", "<cmd>ClaudeCodeSend<cr>", desc = "Send Selection to Claude", mode = "v" },
		},
	},
}
