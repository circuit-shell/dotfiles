return {
	settings = {
		pyright = {
			-- ruff handles import organisation; disable pyright's duplicate pass
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				-- Only analyse open files; avoids false-positives in large monorepos
				diagnosticMode = "openFilesOnly",
				-- uv creates .venv in the project root by default
				venvPath = ".",
			},
		},
	},
}
