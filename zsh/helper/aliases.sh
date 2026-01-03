# ===== Directory Navigation =====

# Quick directory navigation
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -='cd -'  # Previous directory

# Directory shortcuts
alias home='cd ~'
alias gh='cd ~/github.com'
alias dt='cd ~/Desktop'
alias dl='cd ~/Downloads'

# Directory operations
alias md="mkdir -p"
alias cwd="pwd && echo 'Copied to clipboard' && pwd | wl-copy"  # Linux clipboard

# Directory listing
alias l='eza -F --icons'
alias ll='eza -lF --icons'
alias lla='eza -laF --icons'
alias la='eza -aF --icons'
alias lt='eza -T --icons --level=1'  # Tree view level 1
function lt+() { eza -T --icons --level="$1"; }  # Tree with custom level
alias llt='eza -lT --icons'

# Directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd -${index}"; unset index

# ===== File Operations =====

# Create
alias t="touch"
alias md="mkdir -p"

# Delete
alias die="rm -rf"

# Open
alias o="open ./"
alias c="code ."

# ===== Git Aliases =====

# Basic
alias g='git'
alias gs='git status'
alias gst='git status'

# Add
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'

# Commit
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcm='git commit -m'
alias gcmsg='git commit -m'
alias gcam='git commit -a -m'
alias gacmsg="gaa && gcmsg"  # Add all and commit with message

# Branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'

# Checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout main'
alias gcd='git checkout develop'

# Diff
alias gd='git diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'

# Fetch/Pull/Push
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpn="git push --no-verify"
alias gpu='git push -u origin $(git branch --show-current)'

# Log
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glo='git log --oneline --decorate'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'''
alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --stat'

# Stash
alias gsta='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstd='git stash drop'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'

# Reset
alias grh='git reset'
alias grhh='git reset --hard'
alias grhs='git reset --soft'

# Rebase
alias grb='git rebase'
alias grbi='git rebase -i'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# Merge
alias gm='git merge'
alias gma='git merge --abort'

# Clean
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dffx'

# Show
alias gsh='git show'
alias gshs='git show --stat'

# Worktree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtrm='git worktree remove'

# LazyGit
alias lg="lazygit"

# ===== NPM/Node/JavaScript =====

# NPM shortcuts
alias nr="npm run"
alias nrd="npm run dev"
alias nrda="npm run dev:android"
alias nrdi="npm run dev:ios"
alias nota="npm run test-watch"

# Yarn
alias ysd="yarn serve:dev"

# NX
alias nx="npx nx"

# ===== Development Tools =====

# Editors
alias vim='nvim'
alias vi='nvim'
alias nconfig="cd ~/.config/nvim/ && nvim"

# VS Code
alias code="code"
alias c="code ."

# Config files
alias zshconfig="nvim ~/.zshrc"
alias nconfig="cd ~/.config/nvim/ && nvim"

# ===== Golang =====

# Go coverage
alias gocov='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'

# ===== System/Shell =====

# Reload shell
alias reload="source ~/.zshrc"
alias zshsrc="source ~/.zshrc"

# Exit
alias e='exit'

# History
alias h='history'
alias hgrep='history | grep'
alias history='history -200'

# Better defaults
alias cat='bat'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# System info
alias myip='curl ifconfig.me'
alias ports='netstat -tulanp'

# ===== Kitty Terminal =====

# Kitty specific
alias icat="kitten icat"
alias kssh="kitten ssh"


