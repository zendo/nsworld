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
      onedark-theme
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

      set-option -g set-titles on
      set-option -g set-titles-string '#H: #W #T'
    '';
  };
}
