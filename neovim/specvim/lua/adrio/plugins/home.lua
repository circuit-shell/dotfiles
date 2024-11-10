return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Fetch the username from the environment
		local username = os.getenv("USER") or "User" -- Fallback to 'User' if USER is not set

		local header

		if username == "spectr3r-system" then
			header = {
				"			╔═══╗╔═══╗╔═══╗╔═══╗╔════╗╔═══╗╔═══╗╔═══╗     ╔╗  ╔╗╔══╗╔═╗╔═╗     ",
				"			║╔═╗║║╔═╗║║╔══╝║╔═╗║║╔╗╔╗║║╔═╗║║╔══╝║╔═╗║     ║╚╗╔╝║╚╣╠╝║║╚╝║║     ",
				"			║╚══╗║╚═╝║║╚══╗║║ ╚╝╚╝║║╚╝║╚═╝║║╚══╗║╚═╝║     ╚╗║║╔╝ ║║ ║╔╗╔╗║     ",
				"			╚══╗║║╔══╝║╔══╝║║ ╔╗  ║║  ║╔╗╔╝║╔══╝║╔╗╔╝╔═══╗ ║╚╝║  ║║ ║║║║║║     ",
				"			║╚═╝║║║   ║╚══╗║╚═╝║ ╔╝╚╗ ║║║╚╗║╚══╗║║║╚╗╚═══╝ ╚╗╔╝ ╔╣╠╗║║║║║║     ",
				"			╚═══╝╚╝   ╚═══╝╚═══╝ ╚══╝ ╚╝╚═╝╚═══╝╚╝╚═╝       ╚╝  ╚══╝╚╝╚╝╚╝ ",
			}
		else
			header = {
				"                                                                                            ",
				"        ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗         ██╗   ██╗██╗███╗   ███╗      ",
				"       ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║         ██║   ██║██║████╗ ████║      ",
				"       ██║     ███████║██████╔╝██║   ██║   ███████║██║         ██║   ██║██║██╔████╔██║      ",
				"       ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║         ╚██╗ ██╔╝██║██║╚██╔╝██║      ",
				"       ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗     ╚████╔╝ ██║██║ ╚═╝ ██║      ",
				"        ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝      ╚═══╝  ╚═╝╚═╝     ╚═╝      ",
				"                                                                                            ",
			}
		end

		-- Set header with dynamic username
		dashboard.section.header.val = header

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("SPC ee", "  > Toggle File Explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
