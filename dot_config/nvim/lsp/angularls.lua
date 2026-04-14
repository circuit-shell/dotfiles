return {
	root_dir = function(fname)
		return vim.fs.root(fname, { "angular.json", ".angular-cli.json" })
	end,
}
