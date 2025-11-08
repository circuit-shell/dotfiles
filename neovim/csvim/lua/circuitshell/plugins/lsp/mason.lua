return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"eslint",
				"astro",
				"angularls@18.2.0",
				"jsonls",
				"gopls",
				"marksman",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"eslint_d",
				"stylua", -- lua formatter
				"ruff",
				"delve", -- debugger
				"golangci-lint", -- linter
				"yamlfmt", -- formatter
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
