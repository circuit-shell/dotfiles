# Dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io) — a dotfile manager that handles OS-aware templating, private config, and one-command bootstraps across machines.

**Supported platforms:** macOS · Arch Linux · Fedora / generic Linux

---

## Prerequisites

Install chezmoi for your OS:

```sh
# macOS
brew install chezmoi

# Arch Linux
sudo pacman -S chezmoi

# Fedora / other Linux
sh -c "$(curl -fsLS get.chezmoi.io)"
```

---

## Fresh Install

One command bootstraps the entire setup:

```sh
chezmoi init --apply https://github.com/circuit-shell/dotfiles
```

This will:
1. Clone the repo to `~/.local/share/chezmoi`
2. Prompt for your name and email (stored locally, not committed)
3. Deploy all dotfiles appropriate for your OS
4. Create a `~/.zsh/helper/private.sh` stub for private config
5. Fetch the `zsh-vi-mode` plugin

---

## What Gets Deployed

| Tool | Target | Platform |
|---|---|---|
| zsh | `~/.zshrc`, `~/.zsh/helper/` | all |
| tmux | `~/.tmux.conf` | all |
| nvim | `~/.config/nvim/` | all |
| kitty | `~/.config/kitty/kitty.conf` | all (OS variant via template) |
| p10k | `~/.p10k.zsh` | all |
| bash | `~/.bashrc` | all |
| vim | `~/.vimrc` | all |
| vscode | `~/.config/Code/User/settings.json` | all |
| hyprland | `~/.config/hypr/` | Linux only |
| waybar | `~/.config/waybar/` | Linux only |
| wofi | `~/.config/wofi/` | Linux only |
| scripts | `~/.local/bin/` | OS-specific |
| brew packages | via `brew bundle` | macOS only |

---

## Daily Workflow

```sh
# Edit a config (opens the source file in $EDITOR):
chezmoi edit ~/.zshrc

# Apply changes to your home directory:
chezmoi apply

# Preview what would change before applying:
chezmoi diff

# Pull latest changes from remote and apply:
chezmoi update

# Check sync status:
chezmoi status
```

---

## Private Config

On first install, `~/.zsh/helper/private.sh` is created as an empty stub. This file is **not committed to git** — it's the right place for:

- API tokens and secrets
- Machine-specific `PATH` additions
- Tool-specific env vars (Java, Android, Flutter, Go paths, etc.)

See `dot_zsh/helper/private.sh.example` in the repo for common patterns.

---

## Adding a New Config File

```sh
# Tell chezmoi to manage a file:
chezmoi add ~/.config/some/tool.conf

# Edit it through chezmoi:
chezmoi edit ~/.config/some/tool.conf

# Apply:
chezmoi apply
```

---

## macOS Package Management

Packages are defined in `brew/Brewfile`. To install all packages:

```sh
brew bundle --file="$(chezmoi source-path)/brew/Brewfile"
```

To update the Brewfile after installing new packages:

```sh
brew bundle dump --file="$(chezmoi source-path)/brew/Brewfile" --force
```

---

## Arch Linux Notes

On Linux, `chezmoi apply` automatically deploys:
- `~/.config/hypr/` — Hyprland compositor config
- `~/.config/waybar/` — Status bar
- `~/.config/wofi/` — App launcher
- Scripts from `scripts/linux/` → `~/.local/bin/`

macOS-only configs (Brewfile, macOS window decorations, etc.) are excluded automatically.

---

## Repo Layout

```
dotfiles/
├── .chezmoi.toml.tmpl      # Init-time prompts (name, email)
├── .chezmoiignore          # OS-conditional file exclusions
├── .chezmoiexternal.toml   # External resources (zsh-vi-mode)
├── .chezmoiscripts/        # Setup scripts (run_once_, run_onchange_)
├── dot_config/
│   ├── nvim/               # → ~/.config/nvim/
│   ├── kitty/              # → ~/.config/kitty/   (OS template)
│   ├── hypr/               # → ~/.config/hypr/    (Linux only)
│   ├── waybar/             # → ~/.config/waybar/  (Linux only)
│   ├── wofi/               # → ~/.config/wofi/    (Linux only)
│   └── Code/               # → ~/.config/Code/
├── dot_zshrc               # → ~/.zshrc
├── dot_zsh/helper/         # → ~/.zsh/helper/
├── dot_tmux.conf           # → ~/.tmux.conf
├── dot_p10k.zsh            # → ~/.p10k.zsh
├── dot_bashrc              # → ~/.bashrc
├── dot_vimrc               # → ~/.vimrc
├── scripts/
│   ├── macos/              # macOS utility scripts → ~/.local/bin/
│   └── linux/              # Linux utility scripts → ~/.local/bin/
└── brew/
    └── Brewfile
```

**chezmoi prefix conventions:**
- `dot_` → leading `.` in target (e.g. `dot_zshrc` → `~/.zshrc`)
- `executable_` → deployed with mode `0755`
- `.tmpl` → processed as a Go template before writing
- `run_once_` scripts run once per machine; `run_onchange_` re-run when content changes
