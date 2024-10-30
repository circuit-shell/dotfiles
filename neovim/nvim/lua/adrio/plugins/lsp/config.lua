local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

local lang = require("adrio.plugins.lsp.lang")
local opts = require("adrio.plugins.lsp.opts")

local servers = {
	-- prismals = {},
	-- dockerls = {},
	-- bufls = {},
	-- nil_ls = {},
	angularls = lang.angular,
	ts_ls = lang.ts,
	gopls = lang.go,
	lua_ls = lang.lua,
	yamlls = lang.yaml,
	astro = lang.astro,
	rust_analyzer = lang.rust,
	terraformls = { filetypes = { "terraform", "tf" } },
}

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_tool_installer.setup({
	ensure_installed = {
		"prettierd", -- prettierd formatter
		"stylua", -- lua formatter
		"isort", -- python formatter
		"black", -- python formatter
		"pylint", -- python linter
		"eslint_d", -- js linter
		"golangci-lint", -- go linter
	},
})

mason_lspconfig.setup_handlers({
	function(server_name)
		lspconfig[server_name].setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})

-- lspconfig.clangd.setup({
--     on_attach = opts.on_attach,
--     capabilities = opts.capabilities,
--     cmd = {
--         "clangd",
--         "--offset-encoding=utf-16",
--     },
-- })
