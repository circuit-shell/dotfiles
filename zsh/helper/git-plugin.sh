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


