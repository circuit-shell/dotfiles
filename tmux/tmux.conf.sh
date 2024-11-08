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

set -g @resurrect-capture-pane-contents 'on'
set -g @scroll-speed-num-lines-per-scroll 1

# nova theme options
set -g @plugin 'o0th/tmux-nova'
set -g @nova-nerdfonts true
set -g @nova-segment-mode "#{?client_prefix,💀 ,👻 }"
set -g @nova-segment-mode-colors "#59C2FF #242B38"
set -g @nova-segment-whoami "#(pwd)@#h"
set -g @nova-segment-whoami-colors "#59C2FF #242B38"
set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"
set -g @nova-rows 0
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "" # whoami

# tmux-resurrect options
set -g @resurrect-capture-pane-contents 'on'
# tmux-continuum options
set -g @continuum-restore 'on'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

