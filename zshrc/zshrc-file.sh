# #############################################################################
# SECTION: Auto pull dotfiles
# #############################################################################
 echo "Pulling latest changes, please wait..."
 (cd ~/github/dotfiles-latest && git pull >/dev/null 2>&1) || echo "Failed to pull dotfiles"
# #############################################################################


# ###########################################################################
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
# ###########################################################################


# #############################################################################
# SECTION: Autocompletion settings
# These have to be on the top, I remember I had issues this if not
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
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
# zstyle ':completion:*:*:*:*:default' list-colors '${(s.:.)LS_COLORS}'
# #############################################################################


# #############################################################################
# SECTION: Imports
source ~/github/dotfiles-latest/zshrc/helper/functions.sh
source ~/github/dotfiles-latest/zshrc/helper/aliases.sh
source ~/github/dotfiles-latest/zshrc/helper/g-plugin.sh
# #############################################################################


# #############################################################################
# SECTION: Create directories and symlinks
mkdir -p ~/.config
mkdir -p ~/.config/kitty/
mkdir -p ~/github/obsidian_main
create_symlink ~/github/dotfiles-latest/vimrc/vimrc-file ~/.vimrc
create_symlink ~/github/dotfiles-latest/vimrc/vimrc-file ~/github/obsidian_main/.obsidian.vimrc
create_symlink ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc
create_symlink ~/github/dotfiles-latest/tmux/tmux.conf.sh ~/.tmux.conf
create_symlink ~/github/dotfiles-latest/kitty/kitty.conf ~/.config/kitty/kitty.conf
create_symlink ~/github/dotfiles-latest/.prettierrc.yaml ~/.prettierrc.yaml
# create_symlink ~/github/dotfiles-latest/sketchybar/felixkratz ~/.config/sketchybar
# create_symlink ~/github/dotfiles-latest/sketchybar/default ~/.config/sketchybar
# create_symlink ~/github/dotfiles-latest/sketchybar/neutonfoo ~/.config/sketchybar
# #############################################################################


# #############################################################################
# SECTION: history settings
# Current number of entries Zsh is configured to store in memory (HISTSIZE)
# How many commands Zsh is configured to save to the history file (SAVEHIST)
# echo "HISTSIZE: $HISTSIZE"
# echo "SAVEHIST: $SAVEHIST"
# Store 10,000 entries in the command history
HIST_STAMPS="yyyy-mm-dd"
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# Check if the history file exists, if not, create it
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi

# setopt appendhistory
# setopt extendedhistory
# setopt incappendhistory
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
# setopt hist_ignore_space


bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# #############################################################################


## #############################################################################
# SECTION: Detect OS
case "$(uname -s)" in
Darwin)
  OS='Mac'
  ;;
Linux)
  OS='Linux'
  ;;
*)
  OS='Other'
  ;;
esac
# #############################################################################


# #############################################################################
# Section: MacOS-specific configurations
if [ "$OS" = 'Mac' ]; then


  # #############################################################################
  # SECTION: MacOS-specific configurations
  # Stuff that I want to load, but not to have visible in my public dotfiles
  # if [ -f "$HOME/Library/Mobile Documents/com~apple~CloudDocs/github/.zshrc_local" ]; then
    # source "$HOME/Library/Mobile Documents/com~apple~CloudDocs/github/.zshrc_local"
  # fi
  # Configuration below is local only, not in icloud
  # if [ -f "$HOME/.zshrc_local/env-setup.sh" ]; then
    # source "$HOME/.zshrc_local/env-setup.sh"
  # fi
  # Set JAVA_HOME to the OpenJDK installation managed by Homebrew
  export JAVA_HOME="/opt/homebrew/opt/openjdk"
  # Add JAVA_HOME/bin to the beginning of the PATH
  export PATH="$JAVA_HOME/bin:$PATH"

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
  create_symlink ~/github/dotfiles-latest/neovim/kickstart.nvim/ ~/.config/kickstart.nvim
  create_symlink ~/github/dotfiles-latest/neovim/lazyvim/ ~/.config/lazyvim
  create_symlink ~/github/dotfiles-latest/neovim/specvim/ ~/.config/nvim
  # You can use NVIM_APPNAME=nvim-NAME to maintain multiple configurations.
  #
  # NVIM_APPNAME is the name of the directory inside ~/.config
  # For example, you can install the kickstart configuration
  # in ~/.config/nvim-kickstart, the NVIM_APPNAME would be "nvim-kickstart"
  #
  # In my case, the neovim directories inside ~/.config/ are symlinks that point
  # to their respective neovim directories stored in my $my_working_directory
  #
  # Notice that both "v" and "nvim" start "neobean"
  # "vk" opens kickstart and "vl" opens lazyvim
  # alias nvim='export NVIM_APPNAME="nvim" && $(brew --prefix)/bin/nvim'
  alias v='export NVIM_APPNAME="nvim" && "$(brew --prefix)/bin/nvim"'
  # alias vq='export NVIM_APPNAME="quarto-nvim-kickstarter" && "$(brew --prefix)/bin/nvim"'
  # alias vk='export NVIM_APPNAME="kickstart.nvim" && "$(brew --prefix)/bin/nvim"'
  # alias vl='export NVIM_APPNAME="lazyvim" && "$(brew --prefix)/bin/nvim"'


  # Open man pages with nvim
  if command -v nvim &>/dev/null; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
  fi
  # Set up vi mode
  # test {really} long (command) using a { lot } of symbols {page} and {abc} and other ones [find] () "test page" {'command 2'}
  if [ -f "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]; then
    source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    bindkey -r '\e/'
    # Following 4 lines modify the escape key to `kj`
    ZVM_VI_ESCAPE_BINDKEY=kj
    ZVM_VI_INSERT_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
    ZVM_VI_VISUAL_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY
    ZVM_VI_OPPEND_ESCAPE_BINDKEY=$ZVM_VI_ESCAPE_BINDKEY

    function zvm_after_lazy_keybindings() {
      # Remap to go to the beginning of the line
      zvm_bindkey vicmd 'gh' beginning-of-line
      # Remap to go to the end of the line
      zvm_bindkey vicmd 'gl' end-of-line
    }

    # NOTE: My cursor was not blinking when using wezterm with the "wezterm"
    # terminfo, setting it to a blinking cursor below fixed that
    # I also set my term to "xterm-kitty" for this to work
    # This also specifies the blinking cursor
    # ZVM_CURSOR_STYLE_ENABLED=false
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
    # Source .fzf.zsh so that the ctrl+r bindkey is given back fzf
    zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')
  fi
  # ###########################################################################


  # ###########################################################################
  # SECTION: sketchybar
  # This will update the brew package count after running a brew upgrade, brew
  # update or brew outdated command
  # Personally I added "list" and "install", and everything that is after but
  # that's just a personal preference.
  # That way sketchybar updates when I run those commands as well
  if command -v sketchybar &>/dev/null; then
    # When the zshrc file is ran, reload sketchybar, in case the theme was
    # switched
    # I disabled this as it was getting refreshed every time I opened the
    # terminal and if I restored a lot of sessions after rebooting it was a mess
    # sketchybar --reload

    # Define a custom 'brew' function to wrap the Homebrew command.
    function brew() {
      # Execute the original Homebrew command with all passed arguments.
      command brew "$@"
      # Check if the command includes "upgrade", "update", or "outdated".
      if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]] || [[ $* =~ "list" ]] || [[ $* =~ "install" ]] || [[ $* =~ "uninstall" ]] || [[ $* =~ "bundle" ]] || [[ $* =~ "doctor" ]] || [[ $* =~ "info" ]] || [[ $* =~ "cleanup" ]]; then
        # If so, notify SketchyBar to trigger a custom action.
        sketchybar --trigger brew_update
      fi
    }
  fi
  # ###########################################################################


  # ###########################################################################
  # SECTION: Luaver
  # luaver can be used to install multiple lua and luarocks versions
  # Commands below downloads and uses a specific version
  # my_lua_touse=5.1 && luaver install $my_lua_touse && luaver set-default $my_lua_touse && luaver use $my_lua_touse
  # my_luar_touse=3.11.0 && luaver install-luarocks $my_luar_touse && luaver set-default-luarocks $my_luar_touse && luaver use-luarocks $my_luar_touse
  # luarocks install magick
  # luaver install 5.4.6
  #
  # This is in case luaver was installed through homebrew
  # If the file is not empty, then source it
  [ -s $(brew --prefix)/opt/luaver/bin/luaver ] && . $(brew --prefix)/opt/luaver/bin/luaver
  # This is in case it the repo was cloned with the following command
  # git clone https://github.com/DhavalKapil/luaver.git ~/.luaver
  # If the file is not empty, then source it
  [ -s ~/.luaver/luaver ] && . ~/.luaver/luaver
  # Line below won't work with zsh, there's no zsh completions I guess
  # [ -s ~/.luaver/completions/luaver.bash ] && . ~/.luaver/completions/luaver.bash
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
  # Right arrow to accept suggestion
  if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi
  # ###########################################################################


  # ###########################################################################
  # SECTION: z cd replacement
  # Useful commands
  # z foo<SPACE><TAB>  # show interactive completions
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    # alias cd='z'
    # Alias below is same as 'cd -', takes to the previous directory
    alias cdd='z -'
  fi
  # ###########################################################################


  # ###########################################################################
  # SECTION: MySQL
  # Add MySQL client to PATH, if it exists
  if [ -d "/opt/homebrew/opt/mysql-client/bin" ]; then
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
  fi
  # ###########################################################################

  # ###########################################################################
  # SECTION: Google Cloud SDK configurations
  if command -v brew &>/dev/null; then
    if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
      source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    fi
    if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then
      source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
    fi
  fi
  # # Google Cloud SDK.
  # if [ -f '/Users/adrio/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adrio/google-cloud-sdk/path.zsh.inc'; fi
  # if [ -f '/Users/adrio/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adrio/google-cloud-sdk/completion.zsh.inc'; fi
  # ###########################################################################


  # ###########################################################################
  # Initialize kubernetes kubectl completion if kubectl is installed
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#enable-shell-autocompletion
  if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
  fi
  # ###########################################################################


  # ###########################################################################
  # Check if chruby is installed
  # Source chruby scripts if they exist
  # Working instructions to install on macos can be found on the jekyll site
  # https://jekyllrb.com/docs/installation/macos/
  if [ -f "$(brew --prefix)/opt/chruby/share/chruby/chruby.sh" ]; then
    source "$(brew --prefix)/opt/chruby/share/chruby/chruby.sh"
    source "$(brew --prefix)/opt/chruby/share/chruby/auto.sh"
    # Set default Ruby version using chruby
    # Replace 'ruby-3.1.3' with the version you have or want to use
    # You can also put a conditional check here if you want
    chruby ruby-3.1.3
  fi

  # ############################################################################
  # SECTION: Misc config
  ENABLE_CORRECTION="false"
  COMPLETION_WAITING_DOTS="true"
  export HOMEBREW_NO_AUTO_UPDATE="1"
  export LANG=en_US.UTF-8
  export PATH="$(brew --prefix)/bin:$PATH"
  if command -v brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
  fi
  source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  unset ZSH_AUTOSUGGEST_USE_ASYNC
  # ############################################################################


  # ###########################################################################
  # SECTION: zsh-autosuggestions
  # https://github.com/zsh-users/zsh-autosuggestions
  # Right arrow to accept suggestion
  if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi
  # ###########################################################################

  
  # ############################################################################
  # SECTION: languages/tools configuration
  # # flutter
  # export PATH="$PATH:$HOME/development/flutter/bin"
  #
  # # postgreSQL
  # export PATH="$(brew --prefix)/opt/postgresql@16/bin:$PATH"zshconfigzshconfig
  # export PATH="$(brew --prefix)/opt/libpq/bin:$PATH"
  #
  # # python
  # command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  # export PYENV_ROOT="$HOME/.pyenv"
  #
  # # java
  # export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
  # export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
  #
  # # volta
  # export VOLTA_HOME="$HOME/.volta"
  # export PATH="$VOLTA_HOME/bin:$PATH"
  #
  # # golang
  # export GOROOT=$(brew --prefix golang)/libexec
  # export PATH=$PATH:$GOROOT/bin
  
  # # java
  # export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
  # export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator && export PATH=$PATH:$ANDROID_HOME/platform-tools
  #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
  # export SDKMAN_DIR="$HOME/.sdkman"
  # [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
  # ############################################################################
  #

  ############################################################################
  # SECTION: private config
  #
  # source ~/github/dotfiles-latest/zshrc/helper/private.sh
  if [ -f ~/github/dotfiles-latest/zshrc/helper/private.sh ]; then
    source ~/github/dotfiles-latest/zshrc/helper/private.sh
  fi

fi
# ############################################################################

