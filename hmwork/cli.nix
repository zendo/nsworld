{ config, pkgs, ... }:

{
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    cat = "bat";
    ps = "ps -ef";
    # sudo = "sudo -E";
    ip = "ip --color=auto";
    myip = "curl ip.sb";
    ee = "emacs -nw";
    gu = "gitui";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    nboot = "sudo -E nixos-rebuild boot --flake ~/.dotworld#$(hostname)";
    nswitch = "sudo -E nixos-rebuild switch --flake ~/.dotworld#$(hostname)";
    nupgrade = "sudo -E nixos-rebuild switch --flake ~/.dotworld#$(hostname) \\
    --recreate-lock-file";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
  };

  home.file = {
    # ".vimrc".source = ./vimrc;

    ".config/alacritty/alacritty.yml".source = ../others/alacritty.yml;

    ".inputrc".text = ''
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

    # ibus-rime
    # not work!!
    # ".local/share/fcitx5/themes".source = "${(pkgs.fetchFromGitHub {
    #   owner = "hosxy";
    #   repo = "Fcitx5-Material-Color";
    #   rev = "2256feeae48dcc87f19a3cfe98f171862f8fcace";
    #   hash = "sha256-i9JHIJ+cHLTBZUNzj9Ujl3LIdkCllTWpO1Ta4OT1LTc=";
    # })}";

  };

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
      ca = "commit -a -m";
    };
  };

  programs.gpg = {
    enable = true;
  };

  # not sure what?
  # services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 1800;
  #   enableSshSupport = true;
  # };

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

  programs.lf = {
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
    settings = {
      add_newline = true;
      # disable "It took xxs"
      cmd_duration.disabled = true;
    };
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash = {
    enable = true;
    # shellAliases = {
    # };
    # bashrcExtra = ''
    # '';
  };

  programs.fish = {
    enable = false;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    prezto = {
      enable = true;
      prompt.theme = "pure";
    };
    shellAliases = {
      history = "history 0";
    };
    initExtra = ''
      bindkey -e
      setopt no_nomatch
    '';
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
