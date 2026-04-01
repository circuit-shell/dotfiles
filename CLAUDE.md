# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) — a symlink farm manager. Each subdirectory is a "stow package" containing files mirroring their intended locations in `$HOME`.

## Structure

```
dotfiles/
├── macos/          # macOS-specific (brew, kitty, scripts)
├── idempotent/     # Cross-platform (bash, nvim, p10k, tmux, vim, vscode, zsh)
└── arch/           # Arch Linux-specific (hyprland, kitty, scripts)
```

## Installing / Uninstalling Configs

From the repo root, use `stow` with the package path relative to the target:

```sh
# macOS — install a package (e.g., kitty)
stow -v -d macos -t ~ kitty

# macOS — uninstall
stow -v -d macos -t ~ -D kitty

# Cross-platform (idempotent) — install zsh config
stow -v -d idempotent -t ~ zsh

# Arch Linux
stow -v -d arch -t ~ hyprland
```

The `-d` flag sets the stow directory; `-t` sets the target (typically `~`). Some packages have `.stow-local-ignore` to exclude non-symlink files (e.g., `extensions.txt` in vscode).

## macOS Package Management

```sh
# Install all packages from Brewfile
brew bundle --file=macos/brew/Brewfile

# Dump current packages to Brewfile
brew bundle dump --file=macos/brew/Brewfile --force
```

## Key Configs and Their Locations

| Package | Stow dir | Symlinked to |
|---|---|---|
| `zsh` | `idempotent` | `~/.zshrc`, `~/.zsh/` |
| `nvim` | `idempotent` | `~/.config/nvim/` |
| `tmux` | `idempotent` | `~/.tmux.conf` |
| `kitty` | `macos` or `arch` | `~/.config/kitty/` |
| `p10k` | `idempotent` | `~/.p10k.zsh` |
| `vscode` | `idempotent` | `~/.config/Code/User/settings.json` |
| `hyprland` | `arch` | `~/.config/hypr/`, `~/.config/waybar/`, etc. |

## Architecture Notes

**Zsh startup** (`idempotent/zsh/.zshrc`) auto-runs `git pull` on the dotfiles repo every shell session, lazy-loads helpers from `idempotent/zsh/helper/` (aliases, functions, git-plugin, history-settings, private), and does OS detection (`Darwin` / `Linux`) for conditional config.

**Private config** — `idempotent/zsh/helper/private.sh` is gitignored. Copy `private.sh.example` to create it.

**Neovim** (`idempotent/nvim/.config/nvim/`) is fully Lua-based using [Lazy.nvim](https://github.com/folke/lazy.nvim). Plugin specs live in `lua/plugins/`. Prerequisites: Node.js via Volta, Angular language server (`@angular/language-server`).

**Tmux** uses `Ctrl+A` as prefix (not the default `Ctrl+B`). Config at `idempotent/tmux/.tmux.conf`; the `.sh` variant (`tmux.conf.sh`) is a shell-executable version used for OS-conditional clipboard commands — stow ignores it via `.stow-local-ignore`.

**Kitty** auto-attaches to tmux on startup (configured in `kitty.conf`). macOS variant uses `background_opacity 0.9` and titlebar-only decorations; Arch variant differs for that platform.
