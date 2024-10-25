local M = {}

M.ts = require("adrio.plugins.lsp.lang.ts")
M.go = require("adrio.plugins.lsp.lang.go")
M.lua = require("adrio.plugins.lsp.lang.lua")
M.rust = require("adrio.plugins.lsp.lang.rust")
M.yaml = require("adrio.plugins.lsp.lang.yaml")
M.astro = require("adrio.plugins.lsp.lang.astro")

return M
