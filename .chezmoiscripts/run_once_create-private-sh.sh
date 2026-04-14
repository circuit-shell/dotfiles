#!/bin/bash
target="$HOME/.zsh/helper/private.sh"
if [[ ! -f "$target" ]]; then
  mkdir -p "$(dirname "$target")"
  cat > "$target" << 'EOF'
# private.sh — machine-specific env vars and PATH additions
# NOT committed to git. Edit directly on each machine.
# See private.sh.example in the dotfiles repo for reference.

# export MY_TOKEN="..."
# export PATH="$HOME/some/tool/bin:$PATH"
EOF
  chmod 600 "$target"
  echo "Created $target — edit it to add your private config"
fi
