
# Dotfiles

My Personal  dotfiles config for nvim, tmux, p10k, kitty and zsh.

Managed with [chezmoi](https://chezmoi.io) — a dotfile manager that handles OS-aware templating, private config, and one-command bootstraps across machines.

**I use these platforms:** macOS · Arch Linux 

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
chezmoi init --apply --source ~/github.com/circuit-shell/dotfiles https://github.com/circuit-shell/dotfiles
```

This will:
1. Clone the repo to `~/github.com/circuit-shell/dotfiles`
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

## Apply tools individually

**p10k**
```sh
rm -f ~/.p10k.zsh
chezmoi apply ~/.p10k.zsh
chezmoi status ~/.p10k.zsh   # should be empty
```

**vim**
```sh
rm -rf ~/.vim ~/.vimrc
chezmoi apply ~/.vimrc
chezmoi status ~/.vimrc
```

**tmux**
```sh
rm -f ~/.tmux.conf
chezmoi apply ~/.tmux.conf
chezmoi status ~/.tmux.conf
tmux source ~/.tmux.conf   # reload to verify
```

**nvim**
```sh
rm -rf ~/.config/nvim
chezmoi apply ~/.config/nvim
chezmoi status ~/.config/nvim
```

**kitty**
```sh
rm -rf ~/.config/kitty
chezmoi apply ~/.config/kitty
chezmoi status ~/.config/kitty
```

**zsh** (do last — touches the active shell)
```sh
rm -f ~/.zshrc ~/.zprofile
chezmoi apply ~/.zshrc ~/.zsh
# Copy your private config over before opening a new shell:
cp ~/github.com/circuit-shell/dotfiles/idempotent/zsh/helper/private.sh ~/.zsh/helper/private.sh
chezmoi status ~/.zshrc ~/.zsh
```

## Making Changes (repo is the source of truth)

The repo is the source of truth — always edit files here, then apply them to your machine. Never edit deployed files directly in `~/.zshrc`, `~/.config/nvim/`, etc.

### Edit a file in the repo

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

# After applying, commit to git so other machines get the change:
cd $(chezmoi source-path)
git add -A && git commit -m "feat: describe your change"
git push
```

On another machine, pull and apply in one command:

```
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
│   └── kitty/               # → ~/.config/kitty/    (OS template)
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
