{
  config,
  pkgs,
  ...
}: {
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.emacs.d/bin"
  ];

  home.shellAliases = {
    cat = "bat";
    ps = "ps -ef";
    beep = "echo -en \"\\007\"";
    rm = "${pkgs.trash-cli}/bin/trash-put";
    rm-list = "${pkgs.trash-cli}/bin/trash-list";
    rm-empty = "${pkgs.trash-cli}/bin/trash-empty";
    ip = "ip --color=auto";
    ipsb = "curl ip.sb";
    ipinfo = "curl ipinfo.io";

    ee = "emacs -nw";
    yy = "ydict";
    nctb = "nc termbin.com 9999";
    ixio = "curl -F 'f:1=<-' ix.io";
    ssr = "export http_proxy=http://127.0.0.1:20171 ; \\
    export https_proxy=http://127.0.0.1:20171";
    journalctl-1h = "journalctl -p err..alert --since \"60 min ago\"";

    nix-repl-pkgs = "nix repl '<nixpkgs>'";
    nse = "nix search nixpkgs";
    ns-ls = "ls -la /nix/var/nix/profiles";
    ns-readlink = "readlink -f /nix/var/nix/profiles/system";
    ns-generations = "nix profile history --profile /nix/var/nix/profiles/system";
    ns-installed = "nix path-info --recursive /run/current-system";
    ns-diff = "nix profile diff-closures --profile /nix/var/nix/profiles/system";
    ns-switch = "sudo -E nixos-rebuild switch --flake ~/.nsworld#$(hostname)";
    ns-boot = "sudo -E nixos-rebuild boot --flake ~/.nsworld#$(hostname)";
    ns-upgrade = "sudo -E nixos-rebuild boot --flake ~/.nsworld#$(hostname) \\
    --recreate-lock-file";
  };

  home.file = {
    # ".vimrc".source = ./vimrc;

    ".inputrc".text = ''
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

    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
    #   owner = "icy-thought";
    #   repo = "fcitx5-catppuccin";
    #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
    #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
    # };
  };

  programs.git = {
    enable = true;
    userName = "zendo";
    userEmail = "linzway@qq.com";
    aliases = {
      st = "status -sb";
      unstage = "reset HEAD --";
      pr = "pull --rebase";
      pm = "push -u origin main";
      addp = "add --patch";
      comp = "commit --patch";
      co = "checkout";
      ci = "commit";
      cc = "commit -a -m";
      lg = "log --graph --decorate --all --oneline";
    };
  };

  programs.gh = {
    enable = false;
    enableGitCredentialHelper = true;
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
    # ctrl-v show key code
    initExtra = ''
      echo -n "\e[?45l"                 # Fix foot terminal dynamic spinner
      setopt no_nomatch                 # bash wildcard
      unsetopt correct                  # Disable AutoCorrect
      bindkey -e                        # Emacs keybinding
      bindkey "\e[27;2;13~" accept-line # Shift - enter
      bindkey "\e[27;5;13~" accept-line # Ctrl - enter
      bindkey '^H' backward-kill-word   # Ctrl - backspace
      bindkey "^[[1;3C" forward-word    # Alt - ->
      bindkey "^[[1;3D" backward-word   # Alt - <-
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
