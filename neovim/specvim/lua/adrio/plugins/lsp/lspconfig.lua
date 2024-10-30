return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"mason.nvim",
		"mason-lspconfig.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Helper function for setting up LSP keymaps
		local function setup_lsp_keymaps(bufnr)
			local opts = { buffer = bufnr, silent = true }
			local keymaps = {
				{ "n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
				{ "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
				{ "n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
				{ "n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
				{ "n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
				{ { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
				{ "n", "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
				{ "n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
				{ "n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
				{ "n", "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic" },
				{ "n", "]d", vim.diagnostic.goto_next, "Go to next diagnostic" },
				{ "n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
				{ "n", "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
			}

			for _, map in ipairs(keymaps) do
				opts.desc = map[4]
				keymap.set(map[1], map[2], map[3], opts)
			end
		end

		-- Set up LSP keymaps on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				setup_lsp_keymaps(ev.buf)
			end,
		})

		-- Set up capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Set up diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Default handler for installed servers
		local function default_on_attach(client, bufnr)
			-- Add any default on_attach logic here
		end

		-- Server-specific configurations
		local server_configs = {
			svelte = {
				on_attach = function(client, bufnr)
					default_on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end,
			},
			angularls = {
				setup = function()
					local ok, mason_registry = pcall(require, "mason-registry")
					if not ok then
						vim.notify("mason-registry could not be loaded", vim.log.levels.ERROR)
						return
					end

					local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()
					local project_root = vim.fn.getcwd()
					local cmd = {
						"ngserver",
						"--stdio",
						"--tsProbeLocations",
						table.concat({ angularls_path, project_root, vim.uv.cwd() }, ","),
						"--ngProbeLocations",
						table.concat({ angularls_path .. "/node_modules/@angular/language-server", vim.uv.cwd() }, ","),
					}

					return {
						cmd = cmd,
						on_new_config = function(new_config, _)
							new_config.cmd = cmd
						end,
						root_dir = function(fname)
							return lspconfig.util.root_pattern("angular.json", "nx.json")(fname)
								or lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
						end,
					}
				end,
			},
			graphql = {
				filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
			},
			jsonls = {
				filetypes = { "json", "jsonc" },
			},
			gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod"),
				on_attach = function(client, bufnr)
					default_on_attach(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						-- //the following line will be adding a debug print statement
						vim.api.nvim_create_autocmd("BufWritePre", {

							group = vim.api.nvim_create_augroup("LspFormatting", {}),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
					},
				},
			},
			ts_ls = {
				filetypes = {
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"javascript",
					"javascriptreact",
					"javascript.jsx",
				},
				init_options = {
					preferences = {
						disableSuggestions = true,
					},
				},
			},
			emmet_ls = {
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			},
			astro = {
				cmd = { "astro-ls", "--stdio" },
				filetypes = { "astro" },
				root_dir = lspconfig.util.root_pattern("astro.config.js", ".astro"),
			},
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						completion = { callSnippet = "Replace" },
					},
				},
			},
		}

		-- Set up servers
		mason_lspconfig.setup_handlers({
			function(server_name)
				local config = server_configs[server_name] or {}
				config.capabilities = capabilities
				config.on_attach = config.on_attach or default_on_attach

				if config.setup then
					config = vim.tbl_deep_extend("force", config, config.setup())
					config.setup = nil
				end

				lspconfig[server_name].setup(config)
			end,
		})
	end,
}
