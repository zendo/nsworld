{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma6.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = {
      # bcachefs = true;
      zfs = lib.mkForce false; # always broken
    };
  };

  environment.systemPackages = with pkgs; [
    tree
    file
    wget
    curl
    micro
    parted
    gptfdisk
    efibootmgr

    bind
    fd
    ripgrep
    gdu
    duf
    btop
    p7zip
    ouch
  ];

  environment.shellAliases = {
    # proxy
    # ssr_ip=localhost:7890 ; ssr ; ssr-nix-daemon
    ssr = "export {http,https,all}_proxy=socks5h://\${ssr_ip} ;export {HTTP,HTTPS,ALL}_PROXY=socks5h://\${ssr_ip}";
    ssr-nix-daemon = ''
      sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
      sudo tee /run/systemd/system/nix-daemon.service.d/override.conf << EOF
      [Service]
      Environment="http_proxy=socks5h://''${ssr_ip}"
      Environment="https_proxy=socks5h://''${ssr_ip}"
      Environment="all_proxy=socks5h://''${ssr_ip}"
      EOF
      sudo systemctl daemon-reload
      sudo systemctl restart nix-daemon
    '';
    chrome-ssr = ''google-chrome-stable --temp-profile --proxy-server="''${ssr_ip}:7890"'';
  };

  hardware.enableAllFirmware = true;

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings = {
    # substituters = lib.mkForce [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
    trusted-users = [ "@wheel" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  time.timeZone = "Asia/Shanghai";

  # fast but lowest compression level
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
