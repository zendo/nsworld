{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    urlview
    xclip
  ];

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    prefix = "C-x";
    aggressiveResize = true;
    terminal = "xterm-kitty"; # tmux-256color
    shell = "${lib.getExe pkgs.zsh}";
    disableConfirmationPrompt = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      urlview
      fuzzback # ?
      extrakto # tab
      continuum # automatically save 15m
      resurrect # manually save C-s/C-r
      # onedark-theme
    ];
    extraConfig = ''
      # set-option -g prefix2 C-x

      bind m copy-mode

      unbind '"'
      bind 2 splitw -v -c '#{pane_current_path}'
      unbind %
      bind 3 splitw -h -c '#{pane_current_path}'
      bind 0 kill-pane
      bind x swap-pane -D

      # unbind c
      bind t new-window -c "#{pane_current_path}"
      bind k kill-window
      bind b list-windows
      bind Left previous-window
      bind Right next-window

      bind S new-session
      bind Up switch-client -p
      bind Down switch-client -n

      ######################
      ###  DESIGN THEME  ###
      ######################

      # loud or quiet?
      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      # Modes
      setw -g clock-mode-colour colour5
      setw -g mode-style 'fg=colour1 bg=colour18 bold'

      # Title bar
      set -g set-titles on
      set -g set-titles-string '#H: #W #I' # Host W T

      # Pane borders
      set -g pane-border-style fg=colour235 #fg=base02
      set -g pane-active-border-style fg=colour240 #fg=base01

      # Command line
      set -g message-style bright,bg=white,fg=black

      # Status bar
      set -g status-position top
      set -g status-justify left
      set -g status-style 'bg=#282c34 fg=#aab2bf dim'
      set -g status-left ' '
      set -g status-right '#[bg=#282c34,fg=#aab2bf] %m/%d #[fg=colour233,bg=colour8] %H:%M '
      set -g status-right-length 50
      set -g status-left-length 20

      # default window title colors
      setw -g window-status-style 'fg=white,bg=default,dim'
      setw -g window-status-format ' [#S]:#I:#{b:pane_current_path} '

      # active window title colors
      setw -g window-status-current-style 'fg=black bg=brightgreen bold'
      setw -g window-status-current-format ' [#S]:#I#[fg=colour249]:#[fg=black]#{b:pane_current_path} '

      setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'
    '';
  };
}
