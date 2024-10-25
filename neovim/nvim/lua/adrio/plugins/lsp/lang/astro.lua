local lspconfig = require("lspconfig")

return {
	astro = {
		cmd = { "astro-ls", "--stdio" },
		filetypes = { "astro" },
		root_dir = lspconfig.util.root_pattern("astro.config.js", ".astro"),
	},
}
