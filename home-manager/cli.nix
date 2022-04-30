{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    unp
    unrar
    btop
    ctop   # containers monitor
    powertop
    bottom # btm
    psmisc # pstree
    hstr   # hh: history
    ikill
    cht-sh
    tealdeer
    trash-cli
    rage  # age encrypt RIIR
    f2
    choose
    croc
    difftastic # using delta right now
    kalker # calculator
    imagemagick
    ydict
    translate-shell
    # magic-wormhole # python
    magic-wormhole-rs
    aspellDicts.en
    asciinema # record the terminal
    distrobox
    pandoc

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
    # yarn
    gitui
    onefetch
    jq
    jql
    cloc # count code lines
    sqlite
    openssl
    python3

    # Network
    lsof
    mtr
    elinks
    dnspeep
    bandwhich
    traceroute
    speedtest-cli

    # NIX TOOLS
    nixpkgs-fmt
    nixfmt
    alejandra
    rnix-lsp
    lorri
    nix-index
    comma
    manix
    niv
    nvd
    cachix
    nvfetcher
    nixos-generators
    nix-template
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "emacs -nw";
    EDITOR = "emacs -nw";
  };

  home.file = {
    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
    #   owner = "icy-thought";
    #   repo = "fcitx5-catppuccin";
    #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
    #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
    # };
  };

  # ~/.inputrc
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-h" = "backward-kill-word";
    };
    extraConfig = ''
      set bell-style none
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
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.exa = {
    enable = true;
    # ll, la, lla, lt ...
    enableAliases = true;
  };

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

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.skim = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = false;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      # disable "It took xxs"
      # cmd_duration.disabled = true;
    };
  };

  programs.tmux = {
    enable = false;
    extraConfig = ''
      # Set the prefix.
      # set -g prefix M-a

      # Close the current session.
      bind -n M-q kill-session

      # Close the current pane.
      bind -n M-w kill-pane
    '';
  };
}
