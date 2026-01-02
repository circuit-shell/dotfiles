# Powerlevel10k instant prompt
 if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
   fi

   # Load Powerlevel10k
   source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

   # History
   HISTFILE=~/.zsh_history
   HISTSIZE=10000
   SAVEHIST=10000
   setopt SHARE_HISTORY
   setopt HIST_IGNORE_ALL_DUPS
   setopt HIST_FIND_NO_DUPS

   # Completion
   autoload -Uz compinit
   compinit
   zstyle ':completion:*' menu select
   zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

   # Load plugins
   source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
   source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

   # fzf
   source /usr/share/fzf/key-bindings.zsh
   source /usr/share/fzf/completion.zsh
   export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
   export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

   # Aliases
   alias ls='eza --icons'
   alias ll='eza -l --icons'
   alias la='eza -la --icons'
   alias cat='bat'
   alias vim='nvim'
   alias vi='nvim'

   # Keybindings
   bindkey -e
   bindkey '^[[A' history-search-backward
   bindkey '^[[B' history-search-forward

   # Load p10k config
   [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
