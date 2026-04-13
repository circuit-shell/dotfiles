#!/bin/bash

# ─────────────────────────────────────────────────────────────
# setup-desktops.sh
# Opens and arranges apps across 3 virtual desktops.
# Assumes: no apps open, currently on Space 1.
# ─────────────────────────────────────────────────────────────

# ─── Helper: open app if not running, otherwise just focus it ─
open_or_focus() {
    local app="$1"
    if ! pgrep -x "$app" > /dev/null; then
        open -na "$app"
    else
        osascript -e "tell application \"$app\" to activate"
    fi
}

# ─── SPACE 1: Kitty (fullscreen) ──────────────────────────────
open_or_focus "kitty"
sleep 1
# Trigger "Fill" window keybinding (⌃⌥⌘M)
osascript -e 'tell application "System Events" to key code 46 using {control down, option down, command down}'
sleep 1

# ─── Switch to Space 2 ────────────────────────────────────────
osascript -e 'tell application "System Events" to key code 124 using {control down}'
sleep 1

# ─── SPACE 2: Chrome Profile 1 (fullscreen) ───────────────────
# -na ensures a new window for the given profile is brought up
open -a "Google Chrome" --args --profile-directory="Default"
sleep 2
# Trigger "Fill" window keybinding (⌃⌥⌘M)
osascript -e 'tell application "System Events" to key code 46 using {control down, option down, command down}'
sleep 1

# ─── Switch to Space 3 ────────────────────────────────────────
osascript -e 'tell application "System Events" to key code 124 using {control down}'
sleep 1

# ─── SPACE 3: Chrome Profile 2 (left) + Teams (right) ─────────
open -na "Google Chrome" --args --profile-directory="Profile 3"
open_or_focus "Microsoft Teams"
sleep 2

osascript <<'EOF'
-- Focus Chrome and tile it to the left half (⌃⌥⌘←)
tell application "Google Chrome"
    activate
    delay 0.5
end tell
tell application "System Events"
    key code 123 using {control down, option down, command down}
end tell

delay 0.5

-- Focus Teams and tile it to the right half (⌃⌥⌘→)
tell application "Microsoft Teams"
    activate
    delay 1.5
end tell
tell application "System Events"
    key code 124 using {control down, option down, command down}
end tell
EOF

# ─── Force quit Terminal without confirmation prompt ──────────
# Using 'kill' instead of 'quit' bypasses the confirmation dialog
osascript -e 'tell application "System Events" to set procs to every process whose name is "Terminal"' \
          -e 'tell application "Terminal" to close every window' 2>/dev/null
killall Terminal 2>/dev/null

# ─── Show native macOS notification when everything is done ───
osascript -e 'display notification "All desktops are ready 🚀" with title "Setup Desktops"'
