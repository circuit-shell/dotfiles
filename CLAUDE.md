# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [chezmoi](https://chezmoi.io) — a dotfile manager that handles OS-aware templating, private config, and one-command bootstraps. The repo is the single source of truth; files are deployed (copied, not symlinked) to `$HOME` via `chezmoi apply`.

**Supported platforms:** macOS · Arch Linux · Fedora / generic Linux

## Structure

```
dotfiles/
├── .chezmoi.toml.tmpl         # Init-time prompts (name, email); persists sourceDir
├── .chezmoiignore             # OS-conditional exclusions (template)
├── .chezmoiexternal.toml      # External resources (zsh-vi-mode plugin)
├── .chezmoiscripts/           # Setup scripts (run_once_*, run_onchange_*)
├── dot_config/
│   ├── nvim/                  # → ~/.config/nvim/
│   ├── kitty/kitty.conf.tmpl  # → ~/.config/kitty/kitty.conf  (OS-variant template)
│   ├── hypr/                  # → ~/.config/hypr/    (Linux only)
│   ├── waybar/                # → ~/.config/waybar/  (Linux only)
│   ├── wofi/                  # → ~/.config/wofi/    (Linux only)
│   └── mako/                  # → ~/.config/mako/    (Linux only)
├── dot_zshrc                  # → ~/.zshrc
├── dot_zsh/helper/            # → ~/.zsh/helper/
├── dot_tmux.conf              # → ~/.tmux.conf
├── dot_p10k.zsh               # → ~/.p10k.zsh
├── dot_vimrc                  # → ~/.vimrc
├── scripts/
│   ├── macos/                 # macOS utility scripts → ~/.local/bin/ (via run_onchange_)
│   └── linux/                 # Linux utility scripts → ~/.local/bin/ (via run_onchange_)
└── brew/
    └── Brewfile
```

### chezmoi naming conventions

| Source prefix | Meaning |
|---|---|
| `dot_` | Leading `.` in target (`dot_zshrc` → `~/.zshrc`) |
| `.tmpl` suffix | Processed as Go template before writing |
| `run_once_` | Script runs once per machine (tracked in state DB) |
| `run_onchange_` | Script re-runs when its content changes |

## Key Configs and Their Locations

| File | Source | Target | Platform |
|---|---|---|---|
| zsh | `dot_zshrc`, `dot_zsh/helper/` | `~/.zshrc`, `~/.zsh/helper/` | all |
| tmux | `dot_tmux.conf` | `~/.tmux.conf` | all |
| nvim | `dot_config/nvim/` | `~/.config/nvim/` | all |
| kitty | `dot_config/kitty/kitty.conf.tmpl` | `~/.config/kitty/kitty.conf` | macOS (template) |
| p10k | `dot_p10k.zsh` | `~/.p10k.zsh` | all |
| vim | `dot_vimrc` | `~/.vimrc` | all |
| hyprland | `dot_config/hypr/` | `~/.config/hypr/` | Linux only |
| waybar | `dot_config/waybar/` | `~/.config/waybar/` | Linux only |
| wofi | `dot_config/wofi/` | `~/.config/wofi/` | Linux only |
| scripts | `scripts/macos/` or `scripts/linux/` | `~/.local/bin/` | OS-specific |

## Daily Commands

```sh
# Check what's out of sync:
chezmoi status

# Preview changes before writing:
chezmoi diff

# Apply everything:
chezmoi apply

# Pull latest from remote and apply:
chezmoi update
```

## Making Changes

The repo is the source of truth — edit here, then apply.

```sh
# Find the source path for a deployed file:
chezmoi source-path ~/.zshrc
# → /Users/you/github.com/circuit-shell/dotfiles/dot_zshrc

# Or just open the repo directly:
nvim ~/github.com/circuit-shell/dotfiles/dot_zshrc

# Apply a single file or directory:
chezmoi apply ~/.zshrc
chezmoi apply ~/.config/nvim

# After editing, commit and push:
cd $(chezmoi source-path)
git add -A && git commit -m "feat: ..."
git push
```

## macOS Package Management

```sh
# Install all packages from Brewfile:
brew bundle --file="$(chezmoi source-path)/brew/Brewfile"

# Update Brewfile after installing new packages:
brew bundle dump --file="$(chezmoi source-path)/brew/Brewfile" --force
```

## Architecture Notes

**OS detection** happens via Go templates in `.tmpl` files. Use `{{ if eq .chezmoi.os "darwin" }}` for macOS-only config and `{{ else }}` for Linux. The kitty config (`dot_config/kitty/kitty.conf.tmpl`) uses this to set font, shell path, and decorations per platform.

**OS-conditional ignores** are in `.chezmoiignore` (also a template). Patterns match against TARGET paths (e.g., `.config/hypr/**`), not source paths. Linux-only directories are excluded on macOS; the macOS kitty config is excluded on Linux.

**Private config** — `~/.zsh/helper/private.sh` is created as an empty stub by `run_once_create-private-sh.sh` on first apply. It is gitignored. Copy from a backup or use `dot_zsh/helper/private.sh.example` as a reference.

**Zsh startup** (`dot_zshrc`) auto-runs `git pull` on the dotfiles repo every shell session, lazy-loads helpers from `dot_zsh/helper/` (aliases, functions, git-plugin, history-settings, private), and does OS detection for conditional PATH/tool setup.

**Neovim** (`dot_config/nvim/`) is fully Lua-based using [Lazy.nvim](https://github.com/folke/lazy.nvim). Plugin specs live in `lua/plugins/`. Prerequisites: Node.js via Volta, Angular language server (`@angular/language-server`). The `lazy-lock.json` is gitignored (machine-local).

**Tmux** uses `Ctrl+A` as prefix (not the default `Ctrl+B`).

**Kitty** auto-attaches to tmux on startup (configured in `kitty.conf.tmpl`).

**Scripts** — macOS scripts in `scripts/macos/` are copied to `~/.local/bin/` by `run_onchange_deploy-scripts.sh.tmpl` whenever the script directory contents change.

**External plugins** — `zsh-vi-mode` is fetched from GitHub and kept in `~/.zsh/helper/zsh-vi-mode/` via `.chezmoiexternal.toml` (refreshed every 7 days).
