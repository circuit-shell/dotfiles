return {
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
}
