{
  config,
  pkgs,
  username,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
    # wslConf.automount.root = "/mnt"; # defult
    # Not working!!
    # nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  networking.hostName = "wsl";
  # users.defaultUserShell = pkgs.zsh;

  #######################################################################
  ##  Home Manager
  #######################################################################
  home-manager.users.${username} = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      mpg123 # for ydict
      wsl-open
      kitty
      goodvibes
      emacs
    ];

    home.shellAliases = {
      wsl-proxy = "export {http,https,ftp}_proxy=192.168.2.118:10811 ; \\
        export {HTTP,HTTPS,FTP}_PROXY=192.168.2.118:10811";
    };
  };

  #######################################################################
  ##  Basic settings
  #######################################################################
  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    parted
    gptfdisk
    wget
    nix-bash-completions
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # for zsh completion in home-manager
  environment.pathsToLink = [ "/share/zsh" ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";
}
