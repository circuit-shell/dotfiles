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

## Fresh Install (new machine)

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

Then copy your private config:

```sh
# Bring over your machine-specific env vars from a backup or previous machine
cp /path/to/old/private.sh ~/.zsh/helper/private.sh
```

---

## Migrating from Stow (existing machine)

If you're switching from the old Stow-based repo, migrate one tool at a time so nothing breaks mid-migration.

### 1. Install chezmoi and register the repo

```sh
brew install chezmoi   # macOS
chezmoi init --source=/path/to/dotfiles-v2
```

### 2. Migrate each tool

For each tool: **unstow → apply via chezmoi → verify**.

The old stow repo is assumed to be at `~/github.com/circuit-shell/dotfiles`.

**p10k**
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/idempotent -t ~ -D p10k
chezmoi apply ~/.p10k.zsh
chezmoi status ~/.p10k.zsh   # should be empty
```

**vim**
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/idempotent -t ~ -D vim
chezmoi apply ~/.vimrc
chezmoi status ~/.vimrc
```

**tmux**
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/idempotent -t ~ -D tmux
chezmoi apply ~/.tmux.conf
chezmoi status ~/.tmux.conf
tmux source ~/.tmux.conf   # reload to verify
```

**nvim**
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/idempotent -t ~ -D nvim
chezmoi apply ~/.config/nvim
chezmoi status ~/.config/nvim
```

**kitty**
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/macos -t ~ -D kitty
chezmoi apply ~/.config/kitty
chezmoi status ~/.config/kitty
# Open a new kitty window to verify
```

**zsh** (do last — touches the active shell)
```sh
stow -v -d ~/github.com/circuit-shell/dotfiles/idempotent -t ~ -D zsh
chezmoi apply ~/.zshrc ~/.zsh
# Copy your private config over before opening a new shell:
cp ~/github.com/circuit-shell/dotfiles/idempotent/zsh/helper/private.sh ~/.zsh/helper/private.sh
chezmoi status ~/.zshrc ~/.zsh
# Open a new terminal to verify
```

### 3. Finalize

Once all tools are verified, remove the old repo and rename this one:

```sh
rm -rf ~/github.com/circuit-shell/dotfiles
mv ~/github.com/circuit-shell/dotfiles-v2 ~/github.com/circuit-shell/dotfiles
chezmoi init --source=/Users/$USER/github.com/circuit-shell/dotfiles
```

---

## What Gets Deployed

| Tool | Target | Platform |
|---|---|---|
| zsh | `~/.zshrc`, `~/.zsh/helper/` | all |
| tmux | `~/.tmux.conf` | all |
| nvim | `~/.config/nvim/` | all |
| kitty | `~/.config/kitty/kitty.conf` | all (OS variant via template) |
| p10k | `~/.p10k.zsh` | all |
| vim | `~/.vimrc` | all |
| hyprland | `~/.config/hypr/` | Linux only |
| waybar | `~/.config/waybar/` | Linux only |
| wofi | `~/.config/wofi/` | Linux only |
| scripts | `~/.local/bin/` | OS-specific |
| brew packages | via `brew bundle` | macOS only |

---

## Making Changes (repo is the source of truth)

The repo is the source of truth — always edit files here, then apply them to your machine. Never edit deployed files directly in `~/.zshrc`, `~/.config/nvim/`, etc.

### Edit a file in the repo

```sh
# Find the source path for any deployed file:
chezmoi source-path ~/.zshrc
# → /Users/you/github.com/circuit-shell/dotfiles/dot_zshrc

# Open it in your editor (shortcut for the above):
chezmoi edit ~/.zshrc
```

Or just open the repo directly in your editor and edit the file there:

```sh
nvim ~/github.com/circuit-shell/dotfiles/dot_zshrc
nvim ~/github.com/circuit-shell/dotfiles/dot_config/nvim/lua/circuitshell/plugins/ui.lua
# etc.
```

### Preview and apply

```sh
# See what would change before writing anything:
chezmoi diff

# Apply a single file:
chezmoi apply ~/.zshrc

# Apply a whole directory:
chezmoi apply ~/.config/nvim

# Apply everything:
chezmoi apply
```

### Save and sync

```sh
# After applying, commit to git so other machines get the change:
cd $(chezmoi source-path)
git add -A && git commit -m "feat: describe your change"
git push

# On another machine, pull and apply in one command:
chezmoi update
```

---

## Daily Workflow

```sh
# Pull latest changes from remote and apply:
chezmoi update

# Check sync status (anything out of sync?):
chezmoi status

# Preview what would change:
chezmoi diff
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
│   └── wofi/               # → ~/.config/wofi/    (Linux only)
├── dot_zshrc               # → ~/.zshrc
├── dot_zsh/helper/         # → ~/.zsh/helper/
├── dot_tmux.conf           # → ~/.tmux.conf
├── dot_p10k.zsh            # → ~/.p10k.zsh
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
