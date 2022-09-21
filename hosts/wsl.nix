{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  winProxy = "http://192.168.2.118:10811";
in {
  wsl.defaultUser = lib.mkForce "${username}";

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    parted
    gptfdisk
    wget
    nix-bash-completions

    vim
    micro
    # helix
    emacs
    kitty

    wsl-open
  ];

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # noto-fonts-cjk-sans
      # noto-fonts-cjk-serif
      hack-font
      fira-code
      jetbrains-mono
      source-code-pro
      emacs-all-the-icons-fonts
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.variables = {
  };

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=${winProxy} ; \\
    export https_proxy=${winProxy}";
  };
}
