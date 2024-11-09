# =============================
# General Options
# =============================
set -sg escape-time 10 # remove delay for exiting insert mode with ESC in Neovim
set -g mouse on
set -s set-clipboard on
set-option -g status-position top
set-option -g focus-events on

# Terminal Settings
set -g default-terminal "screen-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Vi Mode
set-window-option -g mode-keys vi

# =============================
# Key Bindings
# =============================
# Prefix
unbind C-b
set -g prefix C-a
bind-key C-a send-prefix

# Unbind default keys
unbind C-x
unbind %
unbind '"'
unbind r
unbind -T copy-mode-vi MouseDragEnd1Pane

# Window Navigation
bind -n C-Tab select-window -n
bind -n BTab select-window -p

# Pane Management
bind c new-window -c "#{pane_current_path}"
bind _ split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind a kill-pane
bind m resize-pane -Z

# Pane Resizing
bind -r j resize-pane -D 5
bind -r k resize-pane -U 5
bind -r l resize-pane -R 5
bind -r h resize-pane -L 5

# Other Bindings
bind r source-file ~/.tmux.conf
bind b send-keys -R \; clear-history

# Copy Mode Bindings
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection

# =============================
# Broadcast Commands
# =============================
# Send command to all panes in current session
bind C-e command-prompt -p "Command:" \
  "run \"tmux list-panes -s -F '##{session_name}:##{window_index}.##{pane_index}' \
                | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""

# Send command to all panes in all sessions
bind E command-prompt -p "Command:" \
  "run \"tmux list-panes -a -F '##{session_name}:##{window_index}.##{pane_index}' \
              | xargs -I PANE tmux send-keys -t PANE '%1' Enter\""

# =============================
# Plugins
# =============================
# Plugin Manager
set -g @plugin 'tmux-plugins/tpm'

# Navigation
set -g @plugin 'christoomey/vim-tmux-navigator'

# Mouse Support
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -g @scroll-speed-num-lines-per-scroll 1

# Session Management
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @resurrect-capture-pane-contents 'on'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'

# Status Line
set -g @plugin 'o1th/tmux-nova'
set -g @nova-nerdfonts true
set -g @nova-nerdfonts-first 
set -g @nova-nerdfonts-last 
set -g @nova-nerdfonts-right 
set -g @nova-nerdfonts-left  \u00A0
set -g @nova-pane-active-border-style "default"
set -g @nova-pane-border-style "#F5F5F5"
set -g @nova-status-style-bg "default"
set -g @nova-status-style-fg "#F5F5F5"
set -g @nova-status-style-active-bg "#4A87AF"
set -g @nova-status-style-active-fg "#F5F5F5"
set -g @nova-status-style-double-bg "default"
set -g @nova-pane "#{?pane_in_mode,#{pane_mode},} #W #I"
set -g @nova-segment-whoami "#[fg=#F5F5F5]󰖟  #(ipconfig getifaddr $(route -n get default | grep interface | cut -d: -f2 | tr -d ' '))"
set -g @nova-segment-whoami-colors "#2787AF default"
set -g @nova-rows 1
set -g @nova-segment-mode "#[fg=#F5F5F5]#{?client_prefix,   , 󰳗  }"
set -g @nova-segment-mode-colors "#2787AF default"
set -g @nova-segments-0-left "mode"
set -g @nova-segments-0-right "whoami"
set -g @nova-segment-whoami-colors "#2787AF default"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

