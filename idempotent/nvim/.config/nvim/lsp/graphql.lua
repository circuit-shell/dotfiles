return {
	filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
	root_dir = function(fname)
		return vim.fs.root(fname, { ".graphqlrc", ".graphqlrc.json", ".graphqlrc.yaml", "graphql.config.js" })
	end,
}
