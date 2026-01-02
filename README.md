cd ~/github.com/circuit-shell/dotfiles

cat > README.md << 'EOF'
# Circuit Shell Dotfiles

Personal dotfiles managed with GNU Stow for my Arch Linux development environment.

## 📦 Dependencies

### Required Packages

```bash
# Install all dependencies
yay -S \
  stow \
  kitty \
  zsh \
  tmux \
  neovim \
  zsh-theme-powerlevel10k-git \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-completions \
  fzf \
  zoxide \
  ripgrep \
  fd \
  bat \
  eza \
  ttf-jetbrains-mono-nerd \
  git
```

### Optional but Recommended

```bash
yay -S \
  lazygit \
  gh \
  docker \
  docker-compose
```

## 🚀 Installation

### 1. Clone This Repository

```bash
mkdir -p ~/github.com/circuit-shell
cd ~/github.com/circuit-shell
git clone <your-repo-url> dotfiles
cd dotfiles
```

### 2. Backup Existing Configs

```bash
# Backup any existing configs
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null
mv ~/.tmux.conf ~/.tmux.conf.backup 2>/dev/null
mv ~/.config/kitty ~/.config/kitty.backup 2>/dev/null
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null
mv ~/.p10k.zsh ~/.p10k.zsh.backup 2>/dev/null
```

### 3. Stow Packages

**Important:** Use `--target=$HOME` or `-t ~` flag!

```bash
cd ~/github.com/circuit-shell/dotfiles

# Stow all packages
stow --target=$HOME zsh
stow --target=$HOME p10k
stow --target=$HOME kitty
stow --target=$HOME tmux
stow --target=$HOME nvim

# Or stow all at once
stow -t ~ zsh p10k kitty tmux nvim
```

### 4. Set Zsh as Default Shell

```bash
chsh -s /bin/zsh
```

Log out and back in for changes to take effect.

### 5. Configure Powerlevel10k (First Launch)

Open Kitty and run:

```bash
p10k configure
```

Follow the interactive setup. Config will be saved to `~/.p10k.zsh` (symlinked to dotfiles).

## 📁 Structure

```
dotfiles/
├── kitty/
│   └── .config/
│       └── kitty/
│           └── kitty.conf
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
└── p10k/
    └── .p10k.zsh
```

## 🔄 Updating Dotfiles

### Make Changes

Edit files in the dotfiles directory:

```bash
vim ~/github.com/circuit-shell/dotfiles/zsh/.zshrc
```

Changes are immediately reflected via symlinks!

### Commit Changes

```bash
cd ~/github.com/circuit-shell/dotfiles
git add .
git commit -m "Update zsh config"
git push
```

### Update Existing Symlinks

If you add new files to a package:

```bash
cd ~/github.com/circuit-shell/dotfiles
stow --restow -t ~ <package-name>
```

## 🗑️ Uninstalling

Remove symlinks for a package:

```bash
cd ~/github.com/circuit-shell/dotfiles
stow --delete -t ~ <package-name>

# Example
stow -D -t ~ zsh
```

## 🔍 Verify Installation

Check if symlinks are created correctly:

```bash
ls -la ~ | grep "\->"
ls -la ~/.config/ | grep "\->"
```

Or use readlink:

```bash
readlink ~/.zshrc
readlink ~/.config/kitty
```

## ✨ Features

### Kitty Terminal
- GPU-accelerated rendering
- Catppuccin Mocha color scheme
- JetBrains Mono Nerd Font
- Ligature support

### Zsh Configuration
- Powerlevel10k theme
- Syntax highlighting
- Autosuggestions
- Completions
- fzf integration
- zoxide (smart cd)

### Tmux
- Prefix: `Ctrl+a`
- Vim-style pane navigation
- Mouse support
- 256-color support
- Status bar at top

### Neovim
- Modern Lua configuration
- Line numbers and relative numbers
- Sensible defaults
- Ready for plugin setup

## 🛠️ Quick Stow All Script

```bash
#!/bin/bash
cd ~/github.com/circuit-shell/dotfiles
stow -t ~ zsh p10k kitty tmux nvim
echo "✅ All dotfiles stowed!"
```

Save as `stow-all.sh` and make executable:

```bash
chmod +x ~/github.com/circuit-shell/dotfiles/stow-all.sh
./stow-all.sh
```

## 📝 Notes

- Stow **requires** the `--target=$HOME` flag when run from `~/github.com/circuit-shell/dotfiles`
- Without the target flag, stow will link to the parent directory (`~/github.com/circuit-shell/`)
- Always backup existing configs before stowing
- Symlinks allow instant config updates without re-stowing

## 🆘 Troubleshooting

### Stow says "conflicts"

```bash
# Remove existing file/directory
mv ~/.zshrc ~/.zshrc.old

# Then stow again
stow -t ~ zsh
```

### Symlinks not created

Make sure you're using the target flag:

```bash
cd ~/github.com/circuit-shell/dotfiles
stow --target=$HOME <package-name>
```

### Changes not reflected

Verify symlink exists:

```bash
ls -la ~/.zshrc
```

Should show: `.zshrc -> github.com/circuit-shell/dotfiles/zsh/.zshrc`

## 📚 Resources

- [GNU Stow Documentation](https://www.gnu.org/software/stow/manual/stow.html)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Kitty Terminal](https://sw.kovidgoyal.net/kitty/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

## 📄 License

MIT License - Feel free to use and modify!

---

**Maintained by:** circuit-shell  
**Last Updated:** 2026-01-02
