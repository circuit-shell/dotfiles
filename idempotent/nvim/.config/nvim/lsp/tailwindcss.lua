return {
	root_dir = function(fname)
		return vim.fs.root(fname, {
			"tailwind.config.js",
			"tailwind.config.ts",
			"tailwind.config.mjs",
			"tailwind.config.cjs",
		})
	end,
}
