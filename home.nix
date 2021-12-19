{ config, pkgs, ... }:

let
  spotify-2k = pkgs.symlinkJoin {
    name = "spotify";
    paths = [ pkgs.spotify ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/spotify \
        --add-flags "--force-device-scale-factor=1.8"
    '';
  };

in
{
  home.stateVersion = "21.11";
  home.username = "iab";
  home.homeDirectory = "/home/iab";

  home.packages = with pkgs; [
    # HARDWARE TEST
    efitools
    efibootmgr
    inxi
    lshw
    hwinfo
    cpu-x
    acpi
    usbutils
    dmidecode
    glxinfo
    libva-utils #vainfo
    cpufrequtils
    pciutils
    edid-decode

    # NIX TOOLS
    manix
    nix-bash-completions
    nixos-option
    nixpkgs-fmt
    nixfmt
    rnix-lsp
    direnv
    lorri
    niv

    # develop
    gnumake
    tig
    gitui
    lazygit
    jq
    jql
    openssl
    python3

    # CLI
    dnspeep
    lsof
    elinks
    powertop
    btop
    zenith
    cht-sh
    trash-cli
    fzf
    skim
    unp
    imagemagick
    speedtest-cli
    translate-shell
    aspellDicts.en
    elvish

    # GUI
    v2ray
    qv2ray
    emacsGit
    # emacs
    firefox-wayland
    qbittorrent
    vlc
    # ffmpeg
    audacious
    rhythmbox
    spotify-2k
    # gimp
    shutter
    foliate
    yacreader
    ghostwriter
    tdesktop
    meld
    vorta
    deja-dup
    # standardnotes

    # OFFICE
    # libreoffice-fresh

    # Themes
    # tela-icon-theme
  ];

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status";
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      addp = "add --patch";
      comp = "commit --patch";
      co = "checkout";
      ci = "commit";
    };
  };

  programs.gpg = {
    enable = true;
  };

  home.file.".inputrc".text = ''
    set completion-ignore-case on

    # Show all tab-completion options on first <tab>
    set show-all-if-ambiguous on
    $if Bash
        # In bash only, enable "magic space" so that typing space
        # will show completions. i.e. !!_ (where _ is space)
        # will expand !! for you.
        Space: magic-space
    $endif
  '';

  # home.file.".vimrc".source = ./vimrc;

  home.shellAliases = {
    cat = "bat";
    ps = "ps -ef";
    # sudo = "sudo -E";
    ip = "ip --color=auto";
    ee = "emacs -nw";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    nboot = "sudo -E nixos-rebuild boot --flake ~/.dotworld#nix";
    nswitch = "sudo -E nixos-rebuild switch --flake ~/.dotworld#nix";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \
      export https_proxy=http://127.0.0.1:20171";
  };

  programs.exa = {
    enable = true;
    # ll, la, lla, lt ...
    enableAliases = true;
  };

  # programs.lsd = {
  #   enable = true;
  #   enableAliases = true;
  # };

  programs.bat = {
    enable = true;
  };

  programs.aria2 = {
    enable = true;
  };

  # z: autojump
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # C-r: history search
  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  programs.bash = {
    enable = true;
    # shellAliases = {
    # };
    # bashrcExtra = ''
    # '';
  };

  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = false;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    # oh-my-zsh = {
    #   enable = true;
    #   # plugins = [ "git" "thefuck" ];
    #   theme = "lambda";
    # };
    initExtra = ''
      bindkey -e
    '';
  };

  programs.vscode = {
    enable = true;
    # extensions = with pkgs.vscode-extensions; [
    #   # Nix language support
    #   bbenoist.Nix
    # ];
    # userSettings = {
    #   "editor.formatOnSave" = false;
    #   "editor.minimap.enabled" = false;
    # };
  };

  # programs.emacs = {
  #   enable = true;
  #   #package = (pkgs.emacs.override {
  #   # withXwidgets = true;
  #   #});
  # };
  # home.file.".emacs.d/init.el".source = ./emacs/init.el;
  # home.file.".emacs.d/early-init.el".source = ./emacs/early-init.el;
  # home.file.".emacs.d/lisp".source = ./emacs/lisp;

  programs.vim = {
    enable = true;
    plugins = (with pkgs.vimPlugins; [
      vim-nix
      vim-lsp
      vim-markdown
      rust-vim
      fzf-vim
      vim-colorschemes
    ]);
  };

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      window = {
        padding = {
          x = 6;
          y = 6;
        };
      };
      font = {
        size = 12.0;
        offset = {
          x = 0;
          y = 0;
        };
      };
      # colors = {
      #   };
      key_bindings = [
        { key = "C"; mods = "Control"; action = "Copy"; }
        { key = "V"; mods = "Control"; action = "Paste"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
      ];
    };
  };

  programs.gnome-terminal = {
    enable = true;
    showMenubar = false;
    profile = {
      "5ddfe964-7ee6-4131-b449-26bdd97518f7" = {
        default = true;
        visibleName = "Tomorrow Night";
        cursorShape = "ibeam";
        # customCommand = "/usr/bin/env zsh";
        # font = "DejaVu Sans Mono 11";
        font = "Hack 11";
        # showScrollbar = false;
        # transparencyPercent = 70;
        audibleBell = false;
        colors = {
          foregroundColor = "rgb(197,200,198)";
          palette = [
            "rgb(0,0,0)"
            "rgb(145,34,38)"
            "rgb(119,137,0)"
            "rgb(174,123,0)"
            "rgb(103,123,192)"
            "rgb(104,42,155)"
            "rgb(43,102,81)"
            "rgb(146,149,147)"
            "rgb(102,102,102)"
            "rgb(204,102,102)"
            "rgb(181,189,104)"
            "rgb(240,198,116)"
            "rgb(140,152,191)"
            "rgb(178,148,187)"
            "rgb(138,190,183)"
            "rgb(236,235,236)"
          ];
          boldColor = "rgb(138,186,183)";
          backgroundColor = "rgb(29,31,33)";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      # Set the prefix.
      # set -g prefix M-a

      # Close the current session.
      bind -n M-q kill-session

      # Close the current pane.
      bind -n M-w kill-pane
    '';
  };

  # xdg = {
  #   mimeApps = {
  #     enable = true;
  #     defaultApplications = {
  #       # Documents
  #       "application/pdf" = [ "evince.desktop" ];

  #       # Browsers
  #       "text/html" = [ "firefox.desktop" ];
  #       "x-scheme-handler/http" = [ "firefox.desktop" ];
  #       "x-scheme-handler/https" = [ "firefox.desktop" ];

  #       # Images
  #       "image/jpeg" = [ "eog.desktop" ];
  #       "image/png" = [ "eog.desktop" ];
  #       "image/gif" = [ "eog.desktop" ];
  #       "image/webp" = [ "eog.desktop" ];
  #     };
  #   };
  # };

  # Make cursor not tiny on HiDPI screens
  # xsession.pointerCursor = {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  # };

}
