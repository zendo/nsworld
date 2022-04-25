{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # CLI
    powertop
    unp
    unrar
    btop
    ctop # containers monitor
    bottom # btm
    psmisc # pstree
    cht-sh
    trash-cli
    f2
    choose
    difftastic # using delta right now
    kalker # calculator
    imagemagick
    ydict
    translate-shell
    croc
    # magic-wormhole # python
    magic-wormhole-rs
    aspellDicts.en
    asciinema # record the terminal
    distrobox

    # Develop
    # gcc
    # cmake
    # gnumake
    # nodejs
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
    nix-bash-completions
    nixpkgs-fmt
    nixfmt
    alejandra
    rnix-lsp
    lorri
    comma
    manix
    niv
    nvd
    cachix
    nvfetcher
    nixos-generators
  ];

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

  # C-r: history search
  programs.mcfly = {
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

  programs.bash = {
    enable = true;
    shellAliases = {
      nx = "f() { nix run nixpkgs\#\$1; }; f";
    };
    # bashrcExtra = ''
    # '';
  };

  programs.fish = {
    enable = false;
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
