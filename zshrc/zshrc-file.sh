source ~/github/dotfiles-latest/zshrc/helper/functions.sh
source ~/github/dotfiles-latest/zshrc/helper/aliases.sh

colorscheme_profile="pikachu.sh"
~/github/dotfiles-latest/zshrc/colorscheme-set.sh "$colorscheme_profile"

# ~/.config is used by neovim, alacritty and karabiner
mkdir -p ~/.config
mkdir -p ~/.config/kitty/
mkdir -p ~/github/obsidian_main

# Creating symlinks
create_symlink ~/github/dotfiles-latest/vimrc/vimrc-file ~/.vimrc
create_symlink ~/github/dotfiles-latest/vimrc/vimrc-file ~/github/obsidian_main/.obsidian.vimrc
create_symlink ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc
create_symlink ~/github/dotfiles-latest/tmux/tmux.conf.sh ~/.tmux.conf
create_symlink ~/github/dotfiles-latest/kitty/kitty.conf ~/.config/kitty/kitty.conf
create_symlink ~/github/dotfiles-latest/.prettierrc.yaml ~/.prettierrc.yaml
create_symlink ~/github/dotfiles-latest/neovim/kickstart.nvim/ ~/.config/kickstart.nvim
create_symlink ~/github/dotfiles-latest/neovim/lazyvim/ ~/.config/lazyvim
create_symlink ~/github/dotfiles-latest/neovim/specvim/ ~/.config/nvim

# create_symlink ~/github/dotfiles-latest/sketchybar/felixkratz ~/.config/sketchybar
# create_symlink ~/github/dotfiles-latest/sketchybar/default ~/.config/sketchybar
# create_symlink ~/github/dotfiles-latest/sketchybar/neutonfoo ~/.config/sketchybar

# Autocompletion settings
# https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
# These have to be on the top, I remember I had issues with some autocompletions if not
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

# Current number of entries Zsh is configured to store in memory (HISTSIZE)
# How many commands Zsh is configured to save to the history file (SAVEHIST)
# echo "HISTSIZE: $HISTSIZE"
# echo "SAVEHIST: $SAVEHIST"
# Store 10,000 entries in the command history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
# Check if the history file exists, if not, create it
if [[ ! -f $HISTFILE ]]; then
  touch $HISTFILE
  chmod 600 $HISTFILE
fi
# Append commands to the history file as they are entered
setopt appendhistory
# Record timestamp of each command (helpful for auditing)
setopt extendedhistory
# Share command history data between all sessions
setopt sharehistory
# Incrementally append to the history file, rather than waiting until the shell exits
setopt incappendhistory
# Ignore duplicate commands in a row
setopt histignoredups
# Exclude commands that start with a space
setopt histignorespace

# #############################################################################
#                       AUTO-PULL SECTION
# #############################################################################
 echo "Pulling latest changes, please wait..."
 (cd ~/github/dotfiles-latest && git pull >/dev/null 2>&1) || echo "Failed to pull dotfiles"
# #############################################################################

# Detect OS
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

# macOS-specific configurations
if [ "$OS" = 'Mac' ]; then

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

  # Open man pages in neovim, if neovim is installed
  if command -v nvim &>/dev/null; then
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
  fi

  #############################################################################
  #                        Cursor configuration
  #############################################################################

  # # NOTE: I think the issues with my cursor started happening when I moved to wezterm
  # # and started using the "wezterm" terminfo file, when in wezterm, I switched to
  # # the "xterm-kitty" terminfo file, and the cursor is working great without
  # # the configuration below. Leaving the config here as reference in case it
  # # needs to be tested with another terminal emulator in the future

  # # https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
  # # You can customise the type of cursor you want (blinking or not, |, rectangle or _)
  # # by changing the numbers in the following sequences \e[5 q (5 is for beam, 1 is for block) as follows:
  # #  Set cursor style (DECSCUSR), VT520.
  # # 0  ⇒  blinking block.
  # # 1  ⇒  blinking block (default).
  # # 2  ⇒  steady block.
  # # 3  ⇒  blinking underline.
  # # 4  ⇒  steady underline.
  # # 5  ⇒  blinking bar, xterm.
  # # 6  ⇒  steady bar, xterm.

  # # vi mode
  # bindkey -v
  # export KEYTIMEOUT=1
  #
  # # Change cursor shape for different vi modes.
  # function zle-keymap-select {
  #   if [[ ${KEYMAP} == vicmd ]] ||
  #     [[ $1 = 'block' ]]; then
  #     echo -ne '\e[1 q'
  #   elif [[ ${KEYMAP} == main ]] ||
  #     [[ ${KEYMAP} == viins ]] ||
  #     [[ ${KEYMAP} = '' ]] ||
  #     [[ $1 = 'beam' ]]; then
  #     echo -ne '\e[5 q'
  #   fi
  # }
  # zle -N zle-keymap-select
  # zle-line-init() {
  #   zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  #   echo -ne "\e[5 q"
  # }
  # zle -N zle-line-init
  # echo -ne '\e[5 q'                # Use beam shape cursor on startup.
  # preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.

  #############################################################################
  #                        Colorscheme configuration
  #############################################################################


  #############################################################################

  # Add SSH keys to the agent as these keys won't persist after the computer is restarted
  # Check and add the personal GitHub key
  if [ -f ~/.ssh/key-github-pers ]; then
    ssh-add ~/.ssh/key-github-pers >/dev/null 2>&1
  fi

  # Check and add the work GitHub key
  if [ -f ~/.ssh/id_rsa ]; then
    ssh-add ~/.ssh/id_rsa >/dev/null 2>&1
  fi

  # disable auto-update when running 'brew something'
  export HOMEBREW_NO_AUTO_UPDATE="1"

  # Stuff that I want to load, but not to have visible in my public dotfiles
  if [ -f "$HOME/Library/Mobile Documents/com~apple~CloudDocs/github/.zshrc_local" ]; then
    source "$HOME/Library/Mobile Documents/com~apple~CloudDocs/github/.zshrc_local"
  fi

  # Configuration below is local only, not in icloud
  if [ -f "$HOME/.zshrc_local/env-setup.sh" ]; then
    source "$HOME/.zshrc_local/env-setup.sh"
  fi

  # Set JAVA_HOME to the OpenJDK installation managed by Homebrew
  export JAVA_HOME="/opt/homebrew/opt/openjdk"
  # Add JAVA_HOME/bin to the beginning of the PATH
  export PATH="$JAVA_HOME/bin:$PATH"

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
  alias v='export NVIM_APPNAME="nvim" && /usr/local/bin/nvim'
  alias vq='export NVIM_APPNAME="quarto-nvim-kickstarter" && /usr/local/bin/nvim'
  alias vk='export NVIM_APPNAME="kickstart.nvim" && /usr/local/bin/nvim'
  alias vl='export NVIM_APPNAME="lazyvim" && /usr/local/bin/nvim'
  # I'm also leaving this "nvim" alias, which points to the "nvim" APPNAME, but
  # that APPNAME in fact points to my "neobean" config in the symlinks section
  # If I don't do this, my daily note doesn't work
  #
  # If you want to open the daily note with a different distro, update the "nvim"
  # symlink in the symlinks section
  #
  # If you don't understand what I mean by "daily note" go and watch my daily
  # note video
  # https://youtu.be/W3hgsMoUcqo
  # alias nvim='export NVIM_APPNAME="nvim" && /usr/local/bin/nvim'

  # https://github.com/antlr/antlr4/blob/master/doc/getting-started.md#unix
  # Add antlr-4.13.1-complete.jar to your CLASSPATH
  # export CLASSPATH=".:/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH"
  # Create an alias for running ANTLR's TestRig
  # alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
  # alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.13.1-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

  # export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

  # Add templ to PATH if it is installed
  # templ is installed with
  # go install github.com/a-h/templ/cmd/templ@latest
  # if [ -x "$HOME/go/bin/templ" ]; then
  #   export PATH=$PATH:$HOME/go/bin
  # fi

  # sketchybar
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

  # Luaver
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

  # Brew autocompletion settings
  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
  # -v makes command display a description of how the shell would
  # invoke the command, so you're checking if the command exists and is executable.
  if command -v brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
  fi

  #############################################################################
  #                       Command line tools
  #############################################################################

  # Tool that I use the most and the #1 in my heart is tmux

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
  #
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

    # Eldritch Colorscheme / theme
    # https://github.com/eldritch-theme/fzf
    export FZF_DEFAULT_OPTS='--color=fg:#ebfafa,bg:#09090d,hl:#37f499 --color=fg+:#ebfafa,bg+:#0D1116,hl+:#37f499 --color=info:#04d1f9,prompt:#04d1f9,pointer:#7081d0 --color=marker:#7081d0,spinner:#f7c67f,header:#323449'
  fi

  # Starship
  # Not sure if counts a CLI tool, because it only makes my prompt more useful
  # https://starship.rs/config/#prompt
  # if command -v starship &>/dev/null; then
  #   export STARSHIP_CONFIG=$HOME/github/dotfiles-latest/starship-config/active-config.toml
  #   eval "$(starship init zsh)" >/dev/null 2>&1
  # fi

  # eza
  # ls replacement
  # exa is unmaintained, so now using eza
  # https://github.com/ogham/exa
  # https://github.com/eza-community/eza
  # uses colours to distinguish file types and metadata. It knows about
  # symlinks, extended attributes, and Git.
  if command -v eza &>/dev/null; then
    alias ls='eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
    alias ll='eza -lhg'
    alias lla='eza -alhg'
    alias tree='eza --tree'
  fi

  # Bat -> Cat with wings
  # https://github.com/sharkdp/bat
  # Supports syntax highlighting for a large number of programming and markup languages
  if command -v bat &>/dev/null; then
    # --style=plain - removes line numbers and git modifications
    # --paging=never - doesnt pipe it through less
    alias cat='bat --paging=never --style=plain'
    alias catt='bat'
    alias cata='bat --show-all --paging=never'
  fi

  # Zsh Vi Mode
  # vi(vim) mode plugin for ZSH
  # https://github.com/jeffreytse/zsh-vi-mode
  # Insert mode to type and edit text
  # Normal mode to use vim commands
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

    # Disable the cursor style feature
    # I my cursor above in the cursor section
    # https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#custom-cursor-style
    #
    # NOTE: My cursor was not blinking when using wezterm with the "wezterm"
    # terminfo, setting it to a blinking cursor below fixed that
    # I also set my term to "xterm-kitty" for this to work
    #
    # This also specifies the blinking cursor
    # ZVM_CURSOR_STYLE_ENABLED=false
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
    ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

    # Source .fzf.zsh so that the ctrl+r bindkey is given back fzf
    zvm_after_init_commands+=('[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh')
  fi

  # https://github.com/zsh-users/zsh-autosuggestions
  # Right arrow to accept suggestion
  if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi

  # Changed from z.lua to zoxide, as it's more maintaned
  # smarter cd command, it remembers which directories you use most
  # frequently, so you can "jump" to them in just a few keystrokes.
  # https://github.com/ajeetdsouza/zoxide
  # https://github.com/skywind3000/z.lua
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"

    alias cd='z'
    # Alias below is same as 'cd -', takes to the previous directory
    alias cdd='z -'

    #Since I migrated from z.lua, I can import my data
    # zoxide import --from=z "$HOME/.zlua" --merge

    # Useful commands
    # z foo<SPACE><TAB>  # show interactive completions
  fi

  #############################################################################

  # Add MySQL client to PATH, if it exists
  if [ -d "/opt/homebrew/opt/mysql-client/bin" ]; then
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
  fi

  # Source Google Cloud SDK configurations, if Homebrew and the SDK are installed
  if command -v brew &>/dev/null; then
    if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
      source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    fi
    if [ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]; then
      source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
    fi
  fi

  # Initialize kubernetes kubectl completion if kubectl is installed
  # https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#enable-shell-autocompletion
  if command -v kubectl &>/dev/null; then
    source <(kubectl completion zsh)
  fi

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

fi


# Theme configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# User configuration
# ENABLE_CORRECTION="false"
# COMPLETION_WAITING_DOTS="true"
# HIST_STAMPS="yyyy-mm-dd"
 # ZSH_THEME="spectrer"

# ---- Zoxide (better cd) ----
# eval "$(zoxide init zsh)"

# vi mode
# VI_MODE_SET_CURSOR=true
# VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# VI_MODE_CURSOR_NORMAL=2
# VI_MODE_CURSOR_VISUAL=4
# VI_MODE_CURSOR_INSERT=5
# VI_MODE_CURSOR_OPPEND=0
# INSERT_MODE_INDICATOR="%F{yellow}+%f"
# bindkey -M viins 'jj' vi-cmd-mode

# plugins=(git history yarn copypath safe-pase golang vi-mode)
plugins=(git yarn copypath safe-paste golang)

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# export FZF_BASE="/usr/local/bin/fzf"
# DISABLE_FZF_KEY_BINDINGS="true"
# # DISABLE_FZF_AUTO_COMPLETION="false"
#
# # User configuration
# export CHROME_EXECUTABLE="/Applications/Arc.app/Contents/MacOS/Arc"
# export LANG=en_US.UTF-8
#
# # flutter
# export PATH="$PATH:$HOME/development/flutter/bin"
#
# # postgreSQL
# export PATH="/usr/local/opt/postgresql@16/bin:$PATH"zshconfigzshconfig
# export PATH="/usr/local/opt/libpq/bin:$PATH"
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



# # Google Cloud SDK.
# if [ -f '/Users/adrio/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adrio/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/Users/adrio/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adrio/google-cloud-sdk/completion.zsh.inc'; fi

# oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
if [ -f ${HOME}/.zplug/init.zsh ]; then
    source ${HOME}/.zplug/init.zsh
fi

source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="/usr/local/sbin:$PATH"
