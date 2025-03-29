return {
	-- "goolord/alpha-nvim",
	-- event = "VimEnter",
	-- config = function()
	-- 	local alpha = require("alpha")
	-- 	local dashboard = require("alpha.themes.dashboard")

	-- 	local header = {
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀     circuit-shell-nvim⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣻⣿⣿⣿⣁⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⣀⣤⣤⣤⣤⣠⡶⣿⡏⠉⠉⠉⠉⢙⣿⢷⣦⣤⣤⣤⣤⣀⡀⠀⠀⠀",
	-- 		"⠀⢀⣴⣿⣿⣿⣿⣿⣿⡟⠀⠈⣻⣶⣶⣶⣶⣿⠃⠀⠙⣿⣿⣿⣿⣿⣿⣷⣄⠀",
	-- 		"⠀⠈⠛⠛⠛⠛⠛⠋⣿⠀⠀⣼⠏⠀⠀⠀⠀⠘⢧⡀⠀⢻⡏⠛⠛⠛⠛⠛⠉⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠸⣿⠀⠈⠻⣦⡀⠀⠀⢀⣴⠟⠁⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⣸⡿⠒⠒⢿⣏⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡀⠰⣿⡀⠀⠀⢀⣽⠗⠀⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣄⠈⠁⠀⠀⠈⠁⣠⣾⣿⣤⡀⠀⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡿⠿⢶⣤⣤⡶⠾⠿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⣿⣿⡿⠟⠉⠀⠀⠀⠻⡿⠁⠀⠀⠈⠛⠿⣿⣿⡆⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀",
	-- 		"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
	-- 	}

	-- 	vim.api.nvim_command("highlight DashboardHeader guifg=#FF79C6")

	-- 	-- Set header with custom highlight
	-- 	dashboard.section.header.val = header
	-- 	dashboard.section.header.opts = {
	-- 		position = "center",
	-- 		hl = "DashboardHeader",
	-- 	}
	-- 	-- Set menu
	-- 	dashboard.section.buttons.val = {
	-- 		dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
	-- 		dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
	-- 		dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
	-- 		dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
	-- 	}

	-- 	-- Send config to alpha
	-- 	alpha.setup(dashboard.opts)

	-- 	-- Disable folding on alpha buffer
	-- 	vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	-- end,
}
