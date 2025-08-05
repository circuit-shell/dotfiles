# #####################################################################################
# SECTION: Auto pull dotfiles
# #####################################################################################
 echo "Pulling latest changes, please wait..."
 (cd ~/github.com/dotfiles && git pull >/dev/null 2>&1) || echo "Failed to pull dotfiles"
# #####################################################################################

# #####################################################################################
# SECTION: Misc config
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
export LANG=en_US.UTF-8
# #####################################################################################

# #####################################################################################
# SECTION: SSH key configuration
# # Add SSH keys to the agent as these keys won't persist after the computer is restarted
# # Check and add the personal GitHub key
# if [ -f ~/.ssh/key-github-pers ]; then
#   ssh-add ~/.ssh/key-github-pers >/dev/null 2>&1
# fi
# # Check and add the work GitHub key
# if [ -f ~/.ssh/id_rsa ]; then
#   ssh-add ~/.ssh/id_rsa >/dev/null 2>&1
# fi
# #####################################################################################

# #####################################################################################
# SECTION: Autocompletion settings
# These have to be on the top, I remember I had issues this if not
# https://github.com/zsh-users/zsh-autosuggestions
# Right arrow to accept suggestion
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
unset ZSH_AUTOSUGGEST_USE_ASYNC
zmodload zsh/complist
autoload -U compinit
compinit
_comp_options+=(globdots) # With hidden files
# setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
# Define completers
zstyle ':completion:*' completer _extensions _complete _approximate
# Use cache for commands using cache
zstyle ':completion:*' use-cache on
# You have to use $HOME, because since in "" it will be treated as a literal string
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
# Allow you to select in a menu
zstyle ':completion:*' menu select
# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors '${(s.:.)LS_COLORS}'
# #############################################################################

# #############################################################################
# SECTION: Imports
source ~/github.com/dotfiles/zshrc/helper/functions.sh
source ~/github.com/dotfiles/zshrc/helper/aliases.sh
source ~/github.com/dotfiles/zshrc/helper/git-plugin.sh
# #############################################################################

# #############################################################################
# SECTION: Create directories and symlinks
mkdir -p ~/.config
mkdir -p ~/.config/kitty/
mkdir -p ~/github/obsidian_main
create_symlink ~/github.com/dotfiles/vimrc/vimrc-file ~/.vimrc
create_symlink ~/github.com/dotfiles/vimrc/vimrc-file ~/github/obsidian_main/.obsidian.vimrc
create_symlink ~/github.com/dotfiles/zshrc/zshrc-file.sh ~/.zshrc
create_symlink ~/github.com/dotfiles/tmux/tmux.conf.sh ~/.tmux.conf
create_symlink ~/github.com/dotfiles/kitty/kitty.conf ~/.config/kitty/kitty.conf
create_symlink ~/github.com/dotfiles/.prettierrc.yaml ~/.prettierrc.yaml
# create_symlink ~/github.com/dotfiles/sketchybar/felixkratz ~/.config/sketchybar
# create_symlink ~/github.com/dotfiles/sketchybar/default ~/.config/sketchybar
# create_symlink ~/github.com/dotfiles/sketchybar/neutonfoo ~/.config/sketchybar
# #############################################################################

# #############################################################################
# SECTION: Detect OS
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
# #############################################################################

# #############################################################################
# Section: MacOS-specific configurations
if [ "$OS" = 'Mac' ]; then

  # ############################################################################
  # SECTION: Homebrew
  # Add Homebrew to PATH using eval "$(/opt/homebrew/bin/brew shellenv)"
  # if command -v brew &>/dev/null; then
  #   eval "$(/opt/homebrew/bin/brew shellenv)"
  # fi
  export HOMEBREW_NO_AUTO_UPDATE="1"
  export PATH="$(brew --prefix)/bin:$PATH"
  if command -v brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: install xterm info
  install_xterm_kitty_terminfo() {
    # Attempt to get terminfo for xterm-kitty
    if ! infocmp xterm-kitty &>/dev/null; then
      echo "xterm-kitty terminfo not found. Installing..."
      # Create a temp file
      tempfile=$(mktemp)
      # Download the kitty.terminfo file
      # https://github.com/kovidgoyal/kitty/blob/master/terminfo/kitty.terminfo
      if curl -o "$tempfile" https://raw.githubusercontent.com/kovidgoyal/kitty/master/terminfo/kitty.terminfo; then
        echo "Downloaded kitty.terminfo successfully."
        # Compile and install the terminfo entry for my current user
        if tic -x -o ~/.terminfo "$tempfile"; then
          echo "xterm-kitty terminfo installed successfully."
        else
          echo "Failed to compile and install xterm-kitty terminfo."
        fi
      else
        echo "Failed to download kitty.terminfo."
      fi
      # Remove the temporary file
      rm "$tempfile"
    fi
  }
  install_xterm_kitty_terminfo
  # ############################################################################

  # ############################################################################
  # SECTION: nvim
  create_symlink ~/github.com/dotfiles/neovim/specvim/ ~/.config/nvim
  v() {
    $(brew --prefix)/bin/nvim
  }
  # Set nvim as default editor
  export EDITOR="$(brew --prefix nvim)/bin/nvim"
  # Open man pages with nvim
  if command -v nvim &>/dev/null; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
  fi
  # ############################################################################

  # ############################################################################
  # SECTION: vi mode
  # test {really} long (command) using a { lot } of symbols {page} and {abc} and other ones [find] () "test page" {'command 2'}
  if [ -f "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]; then
    source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    bindkey -r '\e/'
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: sketchybar
  # This will update the brew package count after running a brew upgrade, brew
  # update or brew outdated command
  # Personally I added "list" and "install", and everything that is after but
  # that's just a personal preference.
  # That way sketchybar updates when I run those commands as well
  # if command -v sketchybar &>/dev/null; then
  #   # When the zshrc file is ran, reload sketchybar, in case the theme was
  #   # switched
  #   # I disabled this as it was getting refreshed every time I opened the
  #   # terminal and if I restored a lot of sessions after rebooting it was a mess
  #   # sketchybar --reload

  #   # Define a custom 'brew' function to wrap the Homebrew command.
  #   function brew() {
  #     # Execute the original Homebrew command with all passed arguments.
  #     command brew "$@"
  #     # Check if the command includes "upgrade", "update", or "outdated".
  #     if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
  #       # If so, notify SketchyBar to trigger a custom action.
  #       sketchybar --trigger brew_update
  #     fi
  #   }
  # fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: fzf
  # Initialize fzf if installed
  # https://github.com/junegunn/fzf
  # The following are custom fzf menus I configured
  # hyper+e+n tmux-sshonizer-agen
  # hyper+t+n prime's tmux-sessionizer
  # hyper+c+n colorscheme selector
  #
  # Useful commands
  # ctrl+r - command history
  # ctrl+t - search for files
  # ssh ::<tab><name> - shows you list of hosts in case don't remember exact name
  # kill -9 ::<tab><name> - find and kill a process
  # telnet ::<TAB>

  if [ -f ~/.fzf.zsh ]; then
    # After installing fzf with brew, you have to run the install script
    # echo -e "y\ny\nn" | /opt/homebrew/opt/fzf/install
    source ~/.fzf.zsh
    # Preview file content using bat
    export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
    # Use :: as the trigger sequence instead of the default **
    export FZF_COMPLETION_TRIGGER='::'
    # DISABLE_FZF_KEY_BINDINGS="true"
    # # DISABLE_FZF_AUTO_COMPLETION="false"
    # # export FZF_BASE="$(brew --prefix)/bin/fzf"
    # Eldritch Colorscheme / theme
    # https://github.com/eldritch-theme/fzf
    export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
  fi
  # ###########################################################################


  # ###########################################################################
  # SECTION: eza
  # ls replacement
  if command -v eza &>/dev/null; then
    alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
    alias ll='eza -lhg'
    alias lla='eza -alhg'
    alias tree='eza --tree'
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: Bat -> Cat with wings
  if command -v bat &>/dev/null; then
    # --style=plain - removes line numbers and git modifications
    # --paging=never - doesnt pipe it through less
    alias cat='bat --paging=never --style=plain'
    alias catt='bat'
    alias cata='bat --show-all --paging=never'
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: zsh-syntax-highlighting
  # https://github.com/zsh-users/zsh-syntax-highlighting
  if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: z cd replacement
  # Useful commands
  # z foo<SPACE><TAB> show interactive completions
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    # alias cd='z'
    # Alias below is same as 'cd -', takes to the previous directory
    alias cdd='z -'
  fi
  # ###########################################################################

  # ############################################################################
  # SECTION: powerlevel10k
  source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  # ############################################################################

  # #############################################################################
  # SECTION: private config
  if [ -f ~/github.com/dotfiles/zshrc/helper/private.sh ]; then
    source ~/github.com/dotfiles/zshrc/helper/private.sh
  fi
  # #############################################################################

fi
# ############################################################################

source ~/github.com/dotfiles/zshrc/helper/history-settings.sh
