# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Installation

This config is managed via GNU Stow from the parent `dotfiles/` directory:

```bash
# From dotfiles root
stow -t ~ nvim
```

Prerequisites (macOS):
- Homebrew, Volta, Node (`volta install node`)
- `npm install -g @angular/language-server` for Angular LSP

Plugin bootstrap is automatic — Lazy.nvim installs itself and all plugins on first Neovim launch.

## Architecture

The configuration lives under `lua/circuitshell/` (the project namespace):

- `core/` — Vim options and keymaps, loaded unconditionally
- `lazy.lua` — Lazy.nvim bootstrap and plugin import entry point
- `lsp.lua` — Shared LSP keybindings and diagnostics config applied to all servers
- `plugins/` — One file per plugin or logical group; all files are auto-imported by Lazy
- `after/` — Per-language LSP server configs (merged into the base Mason/lspconfig setup)

### Plugin loading

`lazy.lua` imports `circuitshell.plugins` and `circuitshell.plugins.lsp`, which pulls in every `*.lua` file under those directories. Each plugin spec uses standard Lazy.nvim patterns:

```lua
event = { "BufReadPre", "BufNewFile" }   -- load on file open
cmd = "CommandName"                       -- load on command
keys = { ... }                            -- load on keymap
lazy = false / priority = 1000           -- eager load (colorscheme, etc.)
```

### LSP setup flow

Mason installs servers/tools → `mason-lspconfig` links to `nvim-lspconfig` → base `lspconfig` defaults in `lsp.lua` → per-server overrides in `after/<server>.lua`.

Formatters and linters are separate: `conform.nvim` (format on save) and `nvim-lint` (lint on save/change), both configured in `plugins/code-style.lua`.

## Key mappings reference

- **Leader**: `<Space>`
- **Escape (insert)**: `jk` or `fd`
- **Files**: `<leader>ff` find, `<leader>fr` recent, `<leader>fs` live grep, `<leader>fc` grep word, `<leader>fb` buffers
- **Git**: `<leader>fg` changed files, lazygit via Snacks
- **LSP**: `gd` definition, `gR` references, `gi` implementation, `<leader>ca` code action, `<leader>rn` rename
- **Folds**: `<CR>` toggle (context-aware, only active for code/markup filetypes)
- **Session**: `<C-s>` save file + session

## Copilot conditional loading

`plugins/copilot.lua` checks `vim.fn.system("whoami")` and skips loading for user `spectr3r-system`. Copilot suggestion accept key is `<C-l>` (Tab is intentionally disabled for CopilotChat compatibility).

## Supported languages

TypeScript/JavaScript, Angular (angularls@18.2.0), Svelte, React/JSX, HTML/CSS/Tailwind, GraphQL, JSON, Lua, Go, Python, Markdown, YAML, Astro, Prisma, Emmet.
