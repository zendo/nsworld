{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  wsl.defaultUser = lib.mkForce "${username}";

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "22.05";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    p7zip
    fd
    ripgrep
    gdu
    duf
    pfetch
    neofetch
    wget
    curl
    bind
    nix-bash-completions

    # helix
    neovim
    emacs
    hack-font
    fira-code
    jetbrains-mono
  ];

  environment.shellAliases = {
    wsl-proxy = "export http_proxy=http://192.168.2.118:10811 ; \\
    export https_proxy=http://192.168.2.118:10811";
    wsl-switch = "sudo -E nixos-rebuild switch --flake ~/.nsworld#wsl";
  };
}
