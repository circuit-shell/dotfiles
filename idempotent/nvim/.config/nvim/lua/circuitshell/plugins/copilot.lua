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
			-- Keep Tab free for nvim-cmp
			vim.g.copilot_no_tab_map = true
			-- Accept suggestion with Ctrl+l
			vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })
		end,
	},
	{
		"coder/claudecode.nvim",
		enabled = claude_enabled,
		opts = {
			terminal = {
				snacks_win_opts = {
					keys = {
						nav_left  = { "<C-h>", function() vim.cmd("TmuxNavigateLeft") end,  mode = "t", desc = "Navigate left" },
						nav_down  = { "<C-j>", function() vim.cmd("TmuxNavigateDown") end,  mode = "t", desc = "Navigate down" },
						nav_up    = { "<C-k>", function() vim.cmd("TmuxNavigateUp") end,    mode = "t", desc = "Navigate up" },
						nav_right = { "<C-l>", function() vim.cmd("TmuxNavigateRight") end, mode = "t", desc = "Navigate right" },
					},
				},
			},
		},
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>",       desc = "Toggle Claude Code" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",  desc = "Focus Claude Code" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd<cr>",    desc = "Add Buffer to Claude" },
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Reject Diff" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",   desc = "Send Selection to Claude", mode = "v" },
		},
	},
}
