local ok, mason_registry = pcall(require, "mason-registry")
local lspconfig = require("lspconfig")

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
	table.concat({ angularls_path, project_root }, ","),
	"--ngProbeLocations",
	table.concat({ angularls_path .. "/node_modules/@angular/language-server" }, ","),
}

return {
	angular = {
		cmd = cmd,
		filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
		on_new_config = function(new_config, _)
			new_config.cmd = cmd
		end,
		root_dir = function(fname)
			return lspconfig.util.root_pattern("angular.json", "nx.json")(fname)
				or lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
		end,
	},
}
