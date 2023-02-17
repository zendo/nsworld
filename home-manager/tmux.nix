{ config, pkgs, lib, ... }: {

  home.packages = with pkgs; [
    urlview
    xclip
  ];

  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    baseIndex = 1;
    aggressiveResize = true;
    terminal = "screen-256color";
    shell = "${lib.getExe pkgs.zsh}";
    prefix = "C-x";
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

      unbind '"'
      bind 2 splitw -v -c '#{pane_current_path}'
      unbind %
      bind 3 splitw -h -c '#{pane_current_path}'

      unbind x
      bind 0 kill-pane

      # bind -n M-c new-window -c '#{pane_current_path}'
      bind b list-windows
      bind k kill-window
      bind Left previous-window
      bind Right next-window

      bind C-c new-session
      bind Up switch-client -p
      bind Down switch-client -n

      set-option -g set-titles on
      set-option -g set-titles-string '#H: #W #T'
    '';
  };
}
