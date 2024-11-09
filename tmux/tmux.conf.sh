# Custom options
set-window-option -g mode-keys vi 
set-option -g status-position top
set-option -g focus-events on
set -ag terminal-overrides ",xterm-256color:RGB"
set -g default-terminal "screen-256color"
set -sg escape-time 10 #  remove delay for exiting insert mode with ESC in Neovim
set -g mouse on
set -s set-clipboard on

# Send the same command to all panes/windows in current session
bind C-e command-prompt -p "Command:" \
  "run \"tmux list-panes -s -F '##{session_name}:##{window_index}.##{pane_index}' \
                | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""

# Send the same command to all panes/windows/sessions
bind E command-prompt -p "Command:" \
  "run \"tmux list-panes -a -F '##{session_name}:##{window_index}.##{pane_index}' \
              | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""

# Unbind default key bindings
unbind C-x
unbind C-b
unbind %
unbind '"'
unbind r
unbind -T copy-mode-vi MouseDragEnd1Pane # don't exit copy mode when dragging with mouse

# Set prefix key to Ctrl+a
set -g prefix C-a
bind-key C-a send-prefix

# Navigate windows using Ctrl+Tab and Ctrl+Shift+Tab
bind -n C-Tab select-window -n
bind -n BTab select-window -p

# Clear history under current pane
bind-key b send-keys -R \; clear-history

bind c new-window -c "#{pane_current_path}"
bind _ split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind a kill-pane
bind -r j resize-pane -D 5
bind -r k resize-pane -U 5
bind -r l resize-pane -R 5
bind -r h resize-pane -L 5
bind  m resize-pane -Z
bind r source-file ~/.tmux.conf


bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

# tpm plugin manager
set -g @plugin 'tmux-plugins/tpm'

# list of tmux plugins
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-resurrect' # persist tmux sessions after computer restart
set -g @plugin 'tmux-plugins/tmux-continuum' # automatically saves sessions for you every 15 minutes
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @scroll-speed-num-lines-per-scroll 1
set -g @plugin 'o1th/tmux-nova'

set -g @nova-nerdfonts true
set -g @nova-nerdfonts-first 
set -g @nova-nerdfonts-last 
set -g @nova-nerdfonts-right 
set -g @nova-nerdfonts-left  \u00A0

set -g @nova-pane-active-border-style "#44475a"
set -g @nova-pane-border-style "#282a36"
set -g @nova-status-style-bg "default"
set -g @nova-status-style-fg "#d8dee9"
set -g @nova-status-style-active-bg "#89c0d0"
set -g @nova-status-style-active-fg "#2e3540"
set -g @nova-status-style-double-bg "default"

set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
set -g @nova-segment-mode-colors "#78a2c1 default"

# set -g @nova-segment-net "#(whoami)@#h"
set -g @nova-segment-whoami "󰖟  #(ipconfig getifaddr $(route -n get default | grep interface | cut -d: -f2 | tr -d ' '))󰩩"
set -g @nova-segment-whoami-colors "#78a2c1 default"

set -g @nova-rows 0
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "whoami"
#
# set -g @plugin 'o0th/tmux-nova'

# set -g @nova-segment-mode "#{?client_prefix,💀 ,👻 }"
# # set -g @nova-segment-mode-colors "#BBE67F #242B38"
# set -g @nova-segment-whoami "󰖟  #(ipconfig getifaddr $(route -n get default | grep interface | cut -d: -f2 | tr -d ' '))󰩩"
# # set -g @nova-segment-whoami-colors "#BBE67F #242B38"
# set -g @nova-pane "#W#{?pane_in_mode, (#P),}#I"
# set -g @nova-status-style-double-bg "default"
# set -g @nova-rows 1


# set -g @nova-segments-0-left "mode"
# set -g @nova-segments-0-right "mode"

# set -g @nova-segments-1-left "mode"
# set -g @nova-segments-1-right "whoami" # whoami

# set -g @nova-status-style-bg "default"

# # set -g @nova-nerdfonts true
#  set -g @nova-nerdfonts true

# set -g @nova-nerdfonts-first 
# set -g @nova-nerdfonts-last 

# nova theme options
# set -g @plugin 'o0th/tmux-nova'
# set -g @nova-nerdfonts true
# set -g @nova-segment-mode "#{?client_prefix,💀 ,👻 }"
# set -g @nova-segment-mode-colors "#59c2ff #242B38"
# set -g @nova-segment-whoami "#(pwd)@#h"
# set -g @nova-segment-whoami-colors "#59c2ff #242B38"
# set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"
# set -g @nova-rows 0
# set -g @nova-segments-0-left "mode"
# set -g @nova-segments-0-right "" # whoami

# nova theme options
# set -g @plugin 'o0th/tmux-nova'

# set -g @nova-segment-mode "#{?client_prefix,💀 ,👻 }"
# set -g @nova-segment-mode-colors "#BBE67F #242B38"
# set -g @nova-segment-whoami "󰖟  #(ipconfig getifaddr $(route -n get default | grep interface | cut -d: -f2 | tr -d ' '))󰩩"
# set -g @nova-segment-whoami-colors "#BBE67F #242B38"
# set -g @nova-pane "#W#{?pane_in_mode, (#P),}#I"

# set -g @nova-rows 1
# set -g @nova-status-style-double-bg "default"
# set -g @nova-segments-1-nerdfonts "as" # Clear left segments to rebuild without nerdfonts
# set -g @nova-segments0-right ""  # Clear right segments to rebuild without nerdfonts

# set -g @nova-segments-0-left "mode"
# set -g @nova-segments-0-right "whoami" # whoami
# set -g @nova-status-style-bg "default"


# set -g @nova-nerdfonts true
# set -g @nova-nerdfonts-first 
# set -g @nova-nerdfonts-last 
# set -g @nova-nerdfonts-left
# set -g @nova-nerdfonts-left
#  set -g @nova-nerdfonts-right 

# # For the active (selected) window
# set -g @nova-status-style-active-fg "#110101"   # Text color for active window
#  set -g @nova-status-style-active-bg "#BBE67F"  # Background color for active window

# # # For inactive windows
# set -g @nova-status-style-fg "default"         # Text color for inactive windows
#  set -g @nova-nerdfonts-right 



# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

