{ config, pkgs, username, ... }: {

  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
    # wslConf.automount.root = "/mnt"; # defult
    # nativeSystemd = true; # Not working!!

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  networking.hostName = "wsl";
  # users.defaultUserShell = pkgs.zsh;

  # FIXME: remove it after wsl fix https://github.com/microsoft/WSL/issues/8996
  # from https://github.com/microsoft/WSL/issues/8996#issuecomment-1295953046
  systemd.services.fixshm = {
    enable = true;
    description = "Fix the /dev/shm symlink to be a mount";
    unitConfig = {
      DefaultDependencies = "no";
      Before = [ "sysinit.target" "systemd-tmpfiles-setup-dev.service" "systemd-tmpfiles-setup.service" "systemd-sysctl.service" ];
      ConditionPathExists = "/dev/shm";
      ConditionPathIsSymbolicLink = "/dev/shm";
      ConditionPathIsMountPoint = "/run/shm";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.coreutils}/bin/rm /dev/shm"
        "${pkgs.coreutils}/bin/mkdir /dev/shm"
        "/run/wrappers/bin/umount /run/shm"
        "${pkgs.coreutils}/bin/rmdir /run/shm"
        "/run/wrappers/bin/mount -t tmpfs -o mode=1777,nosuid,nodev,strictatime tmpfs /dev/shm"
        "${pkgs.coreutils}/bin/ln -s /dev/shm /run/shm"
      ];
    };
    wantedBy = [ "sysinit.target" ];
  };

  #######################################################################
  ##  Home Manager
  #######################################################################
  home-manager.users.${username} = { config, pkgs, ... }: {
    home.packages = with pkgs; [
      mpg123 # for ydict
      wsl-open
      kitty
      foot
      emacs
      goodvibes
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
