return {
	"mason-org/mason.nvim",
	version = "^1.0.0",
	dependencies = {
		{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_installation = true,
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				-- "graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"astro",
				"angularls@18.2.0",
				"jsonls",
				"gopls",
				-- "delve",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- javascript
				"prettier", -- formatter
				"eslint_d", -- linter
				"js-debug-adapter", -- debbuger

				-- lua
				"stylua", -- formatter

				-- python
				"ruff", -- linter
				"black", -- formatter
				"isort", -- formatter

				-- go
				"delve", -- debugger
				"golangci-lint", -- linter

				-- yaml
				"yamlfmt", -- formatter
			},
		})
	end,
}
