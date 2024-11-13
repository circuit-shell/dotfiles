return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local header = {
			"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
			"~                                                                                                                                            ~",
			"~                                                                                                                                            ~",
			"~       ____    _____   ______       ____   __    __    _____   ________               _____   __    __    _____   _____       _____         ~",
			"~      / ___)  (_   _) (   __ \\     / ___)  ) )  ( (   (_   _) (___  ___)             / ____\\ (  \\  /  )  / ___/  (_   _)     (_   _)        ~",
			"~     / /        | |    ) (__) )   / /     ( (    ) )    | |       ) )     ________  ( (___    \\ (__) /  ( (__      | |         | |          ~",
			"~    ( (         | |   (    __/   ( (       ) )  ( (     | |      ( (     (________)  \\___ \\    ) __ (    ) __)     | |         | |          ~",
			"~    ( (         | |    ) \\ \\  _  ( (      ( (    ) )    | |       ) )                    ) )  ( (  ) )  ( (        | |   __    | |   __     ~",
			"~     \\ \\___    _| |__ ( ( \\ \\_))  \\ \\___   ) \\__/ (    _| |__    ( (                 ___/ /    ) )( (    \\ \\___  __| |___) ) __| |___) )    ~",
			"~      \\____)  /_____(  )_) \\__/    \\____)  \\______/   /_____(    /__\\               /____/    /_/  \\_\\    \\____\\ \\________/  \\________/     ~",
			"~                                                                                                                                            ~",
			"~                                                                          NVIM                                                              ~",
			"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
		}
		-- Set header with dynamic username
		dashboard.section.header.val = header

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("-", "  > Toggle File Explorer", "<CMD>Oil<CR>"),
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("q", "  > Quit", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
