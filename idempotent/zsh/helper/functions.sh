# mkdir and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# fzf directory search and cd
fcd() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}

# Extract archives
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name
ff() {
  find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
  find . -type d -iname "*$1*"
}

# Create backup of file
backup() {
  cp "$1"{,.bak}
}

# Weather
weather() {
  curl "wttr.in/${1:-}"
}

# AWS
function awsu() {
    export AWS_PROFILE=$1
}

# Clear terminal
function cls() {
  clear && printf '\e[3J'
}

# Kill a port
kp() {
  local port="${1:-4200}"
  kill -9 $(lsof -t -i:$port)
}

# Build Kinesis Advantage Pro Keyboard Config
advmake() {
  # Try to navigate to adv directory
  z_output=$(z adv 2>&1)
  z_status=$?
  
  if [ $z_status -ne 0 ]; then
    # Check if the error is that we're already in the only match
    if [[ "$z_output" == *"zoxide: you are already in the only match"* ]]; then
      echo "Already in adv directory, continuing"
    else
      # It's a different error, show it and exit
      echo "Error: Failed to navigate to adv directory: $z_output" >&2
      return 1
    fi
  else
    z adv
    echo "Successfully navigated to adv directory"
  fi
  
  # Open OrbStack in the background
  if ! open -g -a orbstack; then
    echo "Warning: Failed to open OrbStack, continuing anyway" >&2
  fi
  
  # Pull latest changes
  if ! git pull; then
    echo "Warning: Git pull failed, continuing anyway" >&2
  fi
  
  # Clean firmware files if the directory exists
  if [ -d firmware ]; then
    if ! rm -f firmware/*.uf2; then
      echo "Warning: Failed to remove .uf2 files, continuing anyway" >&2
    fi
  else
    echo "Warning: firmware directory not found, skipping file cleanup" >&2
  fi
  
  # Build the project (critical step)
  if ! make; then
    echo "Error: Make failed" >&2
    return 1
  fi
  
  # Open the directory
  if ! open .; then
    echo "Warning: Failed to open directory in Finder" >&2
  fi
  
  echo "advmake completed successfully"
  return 0
}


