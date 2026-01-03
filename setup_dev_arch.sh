#!/bin/bash
# Arch Linux Development Environment Setup Script
# Run from: ~/github.com/circuit-shell/dotfiles

set -euo pipefail

# --- Directory Check ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$HOME/github.com/circuit-shell/dotfiles"

if [[ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]]; then
  echo "❌ Error: Script must be run from $DOTFILES_DIR"
  echo "Current directory: $SCRIPT_DIR"
  echo ""
  echo "Run these commands first:"
  echo "  mkdir -p ~/github.com/circuit-shell"
  echo "  git clone https://github.com/circuit-shell/dotfiles.git ~/github.com/circuit-shell/dotfiles"
  echo "  cd ~/github.com/circuit-shell/dotfiles"
  echo "  bash setup_dev_arch.sh"
  exit 1
fi

echo "========================================"
echo "  Arch Linux Dev Environment Setup"
echo "========================================"
echo ""

# --- Install Stow ---
echo "📦 Installing stow..."
yay -S stow --noconfirm

# --- Backup Old Configs ---
echo "💾 Backing up existing configs..."
mkdir -p ~/dotfiles-backup
mv ~/.bashrc ~/.vimrc ~/.zshrc ~/.tmux.conf ~/.p10k.zsh ~/dotfiles-backup/ 2>/dev/null || true
mv ~/.config/kitty ~/.config/nvim ~/dotfiles-backup/ 2>/dev/null || true
mv ~/.config/Code/User ~/dotfiles-backup/Code-User 2>/dev/null || true

# --- Stow Configs ---
echo "🔗 Symlinking dotfiles..."
STOW_TARGET=~
stow -t $STOW_TARGET bash kitty neovim p10k tmux vim vscode zsh

# --- Change Shell to Zsh ---
if [[ "$SHELL" != */zsh ]]; then
  echo "🐚 Changing shell to zsh..."
  chsh -s /bin/zsh
  echo "✓ Shell changed to zsh (requires logout)"
fi

# --- System Packages ---
echo "📦 Installing system packages..."
yay -S --noconfirm \
  neovim git gcc make unzip curl wget ripgrep fd fzf xclip wl-clipboard \
  zsh zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting zsh-completions zoxide \
  kitty tmux lazygit zsh-theme-powerlevel10k-git tree-sitter-cli tree-sitter \
  bat eza ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-fira-code ttf-dejavu ttf-liberation \
  noto-fonts noto-fonts-emoji ttf-meslo-nerd

# --- Tmux Plugin Manager ---
echo "🔌 Installing TPM..."
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# --- Lazy.nvim Bootstrap ---
echo "⚡ Bootstrapping lazy.nvim..."
if [[ ! -d ~/.local/share/nvim/lazy/lazy.nvim ]]; then
  git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
    --branch=stable \
    ~/.local/share/nvim/lazy/lazy.nvim
fi

# --- Mise Installation ---
echo "🔧 Installing Mise..."
if ! command -v mise &> /dev/null; then
  curl https://mise.run | sh -s -- --yes
fi
export PATH="$HOME/.local/bin:$PATH"

# --- Language Runtimes with Mise ---
echo "🌐 Installing language runtimes with Mise..."

mise install node@latest
mise use -g node@latest

mise install go@latest
mise use -g go@latest

mise install python@latest
mise use -g python@latest

echo "✓ Mise setup complete"

# --- Docker Setup ---
echo "🐳 Installing Docker..."
yay -S --noconfirm docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
echo "✓ Docker installed (requires logout for group membership)"

# --- Optional: Gaming Tools ---
read -p "Install gaming tools? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "🎮 Installing gaming tools..."
  yay -S --noconfirm \
    steam wine-staging winetricks lutris \
    gamemode mangohud lib32-nvidia-utils \
    heroic-games-launcher-bin bottles protonup-qt
  echo "✓ Gaming tools installed"
fi

# --- Optional: AI/ML Tools ---
read -p "Install AI/ML tools (CUDA, Ollama)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "🤖 Installing AI/ML tools..."
  yay -S --noconfirm cuda cudnn ollama-cuda
  sudo systemctl enable --now ollama
  
  echo "📥 Downloading default LLM models..."
  ollama pull llama3.2
  ollama pull codellama
  
  echo "✓ AI/ML tools installed"
fi

# --- Summary ---
echo ""
echo "========================================"
echo "  ✅ Setup Complete!"
echo "========================================"
echo ""
echo "Installed:"
echo "  • Dotfiles (stowed)"
echo "  • Zsh + Powerlevel10k"
echo "  • Kitty + Tmux + Neovim"
echo "  • Mise (node, go, python)"
echo "  • Docker"
echo ""
echo "⚠️  Action Required:"
echo "  1. Log out and log back in for:"
echo "     - Zsh shell change"
echo "     - Docker group membership"
echo ""
echo "  2. First time in Neovim:"
echo "     nvim"
echo "     (Wait for plugins to install)"
echo "     :Lazy"
echo "     :Mason"
echo ""
echo "  3. First time in Tmux:"
echo "     tmux"
echo "     Ctrl+a I (install plugins)"
echo ""
echo "Test your tools:"
echo "  • mise list"
echo "  • node -v"
echo "  • go version"
echo "  • python --version"
echo "  • docker --version"
echo "  • nvim --version"
echo "  • kitty --version"
echo "  • tmux -V"
echo ""

