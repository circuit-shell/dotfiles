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

function lt+() { eza -T --icons --level="$1"; }  # Tree with custom level
alias llt='eza -lT --icons'

# Directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd -${index}"; unset index

# ===== File Operations =====
alias t="touch"
alias md="mkdir -p"
alias die="rm -rf"
alias o="open ./"

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
alias vi='nvim'

# VS Code
alias c="code ."

# Config files
alias zshconfig="nvim ~/.zshrc"

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
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias diff='diff --color=auto'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# ===== Kitty Terminal =====
alias icat="kitten icat"
alias kssh="kitten ssh"
