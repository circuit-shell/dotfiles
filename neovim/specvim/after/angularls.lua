return {
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
}
