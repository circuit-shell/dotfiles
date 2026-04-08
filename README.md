# Circuit Shell Dotfiles

Personal dotfiles managed with GNU Stow for multiple operating systems.

## Prerequisites

Install GNU Stow on your system:

**macOS:**
```bash
brew install stow
```

**Arch Linux:**
```bash
sudo pacman -S stow
```

## Repository Structure

```
dotfiles/
├── macos/          # macOS-specific configurations
├── idempotent/     # Cross-platform configurations
└── arch/           # Arch Linux-specific configurations
```

## Installation

### macOS

```bash
cd ~/github.com/circuit-shell/dotfiles/macos
rm -rf ~/.config/kitty
stow -t ~ kitty
```

### Idempotent (Cross-Platform)

```bash
cd ~/github.com/circuit-shell/dotfiles/idempotent
```

**Bash:**
```bash
rm -f ~/.bash_profile ~/.bashrc
stow -t ~ bash
```

**P10K:**
```bash
rm -f ~/.p10k.zsh
stow -t ~ p10k
```

**Vim:**
```bash
rm -rf ~/.vim ~/.vimrc
stow -t ~ vim
```

**Zsh:**
```bash
rm -f ~/.zshrc ~/.zprofile
stow -t ~ zsh
```

**Neovim:**
```bash
rm -rf ~/.config/nvim
stow -t ~ nvim
```

**Tmux:**
```bash
rm -f ~/.tmux.conf
stow -t ~ tmux
```

**VSCode:**
```bash
rm -rf ~/.config/Code
stow -t ~ vscode
```

### Arch Linux

```bash
cd ~/github.com/circuit-shell/dotfiles/arch
rm -rf ~/.config/kitty
stow -t ~ kitty
```

## Uninstalling

To remove symlinks for a specific configuration:

```bash
cd ~/github.com/circuit-shell/dotfiles/[macos|idempotent|arch]
stow -D -t ~ [configuration-name]
```

## Removing All Stows

```bash
cd /usr/local/stow/
stow -D [package-name]
sudo rm -rf /usr/local/stow/[package-name]
```
#989898