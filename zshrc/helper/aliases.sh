
# Pomo timer
# Requires https://github.com/caarlos0/timer to be installed
alias work="timer 60m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -appIcon '~/Pictures/gopher.png'\
        -sound Crystal"
alias rest="timer 10m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -appIcon '~/Pictures/gopher.png'\
        -sound Crystal"

alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias c="code ."
alias ~="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias md="mkdir -p"
alias t="touch"
alias cwd="pwd && echo 'Copied to clipboard' && copydir"
alias die="rm -rf"
alias gacmsg="gaa && gcmsg"
alias gpn="git push --no-verify"
alias lg="lazygit"
alias lt+="tree -aL"
alias lt="tree -aL 1"
alias nota="npm run test-watch"
alias nr="npm run"
alias nrd="npm run dev"
alias nrda="npm run dev:android"
alias nrdi="npm run dev:ios"
alias nx="npx nx"
alias o="open ./"
alias ohmycolor="spectrum_ls"
alias ohmyzsh="code ~/.oh-my-zsh"
alias po="popd"
alias t="touch"
alias ysd="yarn serve:dev"
alias zshconfig="nvim ~/.zshrc"
alias zshsrc="source ~/.zshrc"
alias reload="source ~/.zshrc"
alias nconfig="cd ~/.config/nvim/ && nvim"
alias advmake="z adv && open -a orbstack && git pull && rm -f firmware/*.uf2 && make && open ."
alias e='exit'
alias ll='ls -lh'
alias lla='ls -alh'
alias python='python3'
alias history='history -30'

# kubernetes, if you need help, just run 'kgp --help' for example
alias k='kubectl'
alias kx='kubectx'
# alias ks='kubeswap'
alias ks='kubens'
alias kga='kubectl get all'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpo='kubectl get pods -o wide'

# golang aliases
alias gocov='go test -coverprofile=coverage.out && go tool cover -html=coverage.out'

kp() {
  local port="${1:-4200}"
  kill -9 $(lsof -t -i:$port)
}

