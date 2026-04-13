return {
	cmd = { "astro-ls", "--stdio" },
	filetypes = { "astro" },
	root_dir = function(fname)
		return vim.fs.root(fname, { "astro.config.js", "astro.config.ts", "astro.config.mjs", ".astro" })
	end,
}
