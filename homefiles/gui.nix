{ config, pkgs, ... }:

{
  xdg.desktopEntries.spotify = {
    name = "Spotify";
    genericName = "Music Player";
    icon = "spotify-client";
    exec = "spotify %U --force-device-scale-factor=2";
    terminal = false;
    categories = [ "Application" "Music" ];
  };

  programs.alacritty = {
    enable = false;
  };
  xdg.configFile."alacritty/alacritty.yml".source = ../others/alacritty.yml;

  programs.foot = {
    enable = true;
    # server.enable = false;
  };
  xdg.configFile."foot/foot.ini".source = ../others/foot.ini;

  programs.vscode = {
    enable = true;
    # extensions = with pkgs.vscode-extensions; [
    #   ms-ceintl.vscode-language-pack-zh-hans
    #   mattn.lisp
    #   jnoortheen.nix-ide
    # ];
    # userSettings = {
    #   "editor.formatOnSave" = false;
    #   "editor.minimap.enabled" = false;
    # };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
    # package = pkgs.emacsGit;
    extraPackages = epkgs: [
      epkgs.vterm
      # epkgs.telega
    ];
  };

  # home.file.".doom.d".source = ../emacs/doom;
  # home.file.".emacs.d/custom.el".source = ../emacs/centaur/custom.el;
  # home.file.".emacs.d/custom-post.el".source = ../emacs/centaur/custom-post.el;
  # home.file.".emacs.d/init.el".source = ../emacs/init.el;
  # home.file.".emacs.d/early-init.el".source = ../emacs/early-init.el;
  # home.file.".emacs.d/lisp".source = ../emacs/lisp;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lsp
      vim-markdown
    ];
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "onedark";
      # editor.file-picker.hidden = true;
      lsp.display-messages = true;
      keys.normal = {
        space.space = "file_picker";
        space.q = ":q";
      };
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      hwdec = "vappi";
      gpu-api = "vulkan";
      gpu-context = "wayland";
      osd-on-seek = "msg";
    };
  };

  # cursor
  # xsession.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

}
