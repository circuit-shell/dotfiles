# #####################################################################################
# SECTION: Auto pull dotfiles
# #####################################################################################
echo "Pulling latest changes, please wait..."
(cd ~/github.com/circuit-shell/dotfiles && git pull >/dev/null 2>&1) || echo "Failed to pull dotfiles"
# #####################################################################################

# #####################################################################################
# SECTION: Detect OS (Must be early)
# #####################################################################################
case "$(uname -s)" in
  Darwin)
    OS='Mac'
    echo "Mac OS detected"
    ;;
  Linux)
    OS='Linux'
    echo "Linux OS detected"
    ;;
  *)
    OS='Other'
    echo "Other OS detected"
    ;;
esac
# #####################################################################################

# #####################################################################################
# SECTION: Powerlevel10k Instant Prompt
# #####################################################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# #####################################################################################

# #####################################################################################
# SECTION: Misc Config
# #####################################################################################
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
export LANG=en_US.UTF-8
# #####################################################################################

# #####################################################################################
# SECTION: History Settings
# #####################################################################################
HIST_STAMPS="yyyy-mm-dd"
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Check if history file exists, if not, create it
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi

setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

echo "History settings configured"
# #####################################################################################

# #####################################################################################
# SECTION: Autocompletion Settings
# #####################################################################################
zmodload zsh/complist
autoload -U compinit
compinit
_comp_options+=(globdots)

# setopt MENU_COMPLETE
setopt AUTO_LIST
setopt COMPLETE_IN_WORD

# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' complete true
zstyle ':completion:*' menu select
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:*:*:*:default' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# #####################################################################################

# #####################################################################################
# SECTION: OS-Specific Configurations
# #####################################################################################
if [ "$OS" = 'Mac' ]; then
  # ---------------------------------------------------------------------------
  # SUBSECTION: Homebrew
  # ---------------------------------------------------------------------------
  export HOMEBREW_NO_AUTO_UPDATE="1"
  if command -v brew &>/dev/null; then
    export PATH="$(brew --prefix)/bin:$PATH"
    export PATH="$(brew --prefix)/sbin:$PATH"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
  
  # ---------------------------------------------------------------------------
  # SUBSECTION: xterm-kitty terminfo
  # ---------------------------------------------------------------------------
  install_xterm_kitty_terminfo() {
    if ! infocmp xterm-kitty &>/dev/null; then
      echo "xterm-kitty terminfo not found. Installing..."
      tempfile=$(mktemp)
      if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
        echo "Downloaded kitty.terminfo successfully."
        if tic -x -o ~/.terminfo "$tempfile"; then
          echo "xterm-kitty terminfo installed successfully."
        else
          echo "Failed to compile and install xterm-kitty terminfo."
        fi
      else
        echo "Failed to download kitty.terminfo."
      fi
      rm "$tempfile"
    fi
  }
  install_xterm_kitty_terminfo
  
  # ---------------------------------------------------------------------------
  # SUBSECTION: Neovim
  # ---------------------------------------------------------------------------
 # get_nvim_path() {
 #   if [[ -f ~/nvim-macos-arm64/bin/nvim ]]; then
 #     echo "$HOME/nvim-macos-arm64/bin/nvim"
 #   elif command -v brew &>/dev/null && [[ -f "$(brew --prefix nvim)/bin/nvim" ]]; then
 #     echo "$(brew --prefix nvim)/bin/nvim"
 #   elif command -v nvim &>/dev/null; then
 #     command -v nvim
 #   else
 #     echo "nvim not found" >&2
 #     return 1
 #   fi
 # }

 # v() {
 #   local nvim_path=$(get_nvim_path)
 #   if [[ $? -eq 0 ]]; then
 #     $nvim_path "$@"
 #   fi
 # }

 # export EDITOR=$(get_nvim_path)

 # if command -v nvim &>/dev/null || [[ -f ~/nvim-macos-arm64/bin/nvim ]] || \
 #    (command -v brew &>/dev/null && [[ -f "$(brew --prefix nvim)/bin/nvim" ]]); then
 #   export MANPAGER='$(get_nvim_path) +Man!'
 #   export MANWIDTH=999
 # fi
  
  # ---------------------------------------------------------------------------
  # SUBSECTION: Plugins (macOS paths)
  # ---------------------------------------------------------------------------
  # Autosuggestions
  [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  
  # Vi mode
  [[ -f "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]] && \
    source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh && \
    bindkey -r '\e/'
  
  # Syntax highlighting (must be last)
  [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  
  # fzf
  if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
    export FZF_COMPLETION_TRIGGER='::'
    export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
  fi
  
  # Powerlevel10k
  [[ -f "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" ]] && \
    source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

elif [ "$OS" = 'Linux' ]; then
  # ---------------------------------------------------------------------------
  # SUBSECTION: Neovim (Linux)
  # ---------------------------------------------------------------------------
  if command -v nvim &>/dev/null; then
    alias v='nvim'
    alias vim='nvim'
    alias vi='nvim'
    export EDITOR='nvim'
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
  fi
  
  # ---------------------------------------------------------------------------
  # SUBSECTION: Plugins (Linux paths)
  # ---------------------------------------------------------------------------
  # Autosuggestions
  [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  
  # Vi mode
  [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  
  # Syntax highlighting (must be last)
  [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  
  # fzf
  if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
    export FZF_COMPLETION_TRIGGER='::'
    export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
  fi
  
  # Powerlevel10k
  [[ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] && \
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi
# #####################################################################################

# #####################################################################################
# SECTION: Universal Tools (Work on both OS)
# #####################################################################################

# ---------------------------------------------------------------------------
# SUBSECTION: eza (ls replacement)
# ---------------------------------------------------------------------------
if command -v eza &>/dev/null; then
  alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --all'
  alias ll='eza -lhg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
fi

# ---------------------------------------------------------------------------
# SUBSECTION: bat (cat replacement)
# ---------------------------------------------------------------------------
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  alias cata='bat --show-all --paging=never'
fi

# ---------------------------------------------------------------------------
# SUBSECTION: zoxide (cd replacement)
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cdd='z -'
fi

# ---------------------------------------------------------------------------
# SUBSECTION: Common Aliases
# ---------------------------------------------------------------------------
alias grep='grep --color=auto'
alias diff='diff --color=auto'
# #####################################################################################

# #####################################################################################
# SECTION: History Keybindings (Fixed for both macOS and Linux)
# #####################################################################################
# Standard arrow key bindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Alternative bindings (some terminals use different codes)
bindkey '^[OA' history-search-backward
bindkey '^[OB' history-search-forward

# Ctrl+P and Ctrl+N (vi-style)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

echo "History keybindings configured for $(tput bold)$(tput setaf 2)both platforms$(tput sgr0)"
# #####################################################################################

# #####################################################################################
# SECTION: mise (runtime manager)
# #####################################################################################
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
  echo "mise activated"
fi
# #####################################################################################

# #####################################################################################
# SECTION: Load p10k config
# #####################################################################################
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# #####################################################################################

# #####################################################################################
# SECTION: Load Helper Files (MUST BE LAST - after all plugins loaded)
# #####################################################################################
[[ -f ~/github.com/circuit-shell/dotfiles/zsh/helper/functions.sh ]] && \
  source ~/github.com/circuit-shell/dotfiles/zsh/helper/functions.sh

[[ -f ~/github.com/circuit-shell/dotfiles/zsh/helper/aliases.sh ]] && \
  source ~/github.com/circuit-shell/dotfiles/zsh/helper/aliases.sh

[[ -f ~/github.com/circuit-shell/dotfiles/zsh/helper/git-plugin.sh ]] && \
  source ~/github.com/circuit-shell/dotfiles/zsh/helper/git-plugin.sh

[[ -f ~/github.com/circuit-shell/dotfiles/zsh/helper/private.sh ]] && \
  source ~/github.com/circuit-shell/dotfiles/zsh/helper/private.sh
# #####################################################################################

# Unset autosuggestions async (from your config)
# unset ZSH_AUTOSUGGEST_USE_ASYNC

export PATH="/usr/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
