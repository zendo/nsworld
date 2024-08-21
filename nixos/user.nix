{
  lib,
  config,
  username,
  ...
}:
let
  inherit (lib) mkIf;

  sudoRule = {
    users = [ "${username}" ];
    commands = [
      {
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
    ];
  };
in
{
  users = {
    # mutableUsers = false;
    # defaultUserShell = pkgs.zsh;
  };

  users.users.${username} = {
    isNormalUser = true;
    # `mkpasswd`
    hashedPassword = "$y$j9T$aNhZV153pAbvGMeFqjGmn.$iH18jxovF5Huof8U4NNPK/EVWHH75o5x8lRzq8IHZO3";
    # ssh-copy-id -i ~/.ssh/id_ed25519.pub nixos@192.168.122.85
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz linzway@qq.com"
    ];
    extraGroups = [
      "wheel"
      (mkIf config.virtualisation.lxd.enable "lxd")
      (mkIf config.virtualisation.docker.enable "docker")
      (mkIf config.virtualisation.podman.enable "podman")
      (mkIf config.virtualisation.libvirtd.enable "libvirtd")
      (mkIf config.virtualisation.virtualbox.host.enable "vboxusers")
      (mkIf config.programs.adb.enable "adbusers")
    ];
  };

  users.users.guest = {
    isNormalUser = true;
    # `passwd`
    password = "guest";
    extraGroups = [
      (mkIf config.virtualisation.lxd.enable "lxd")
      (mkIf config.virtualisation.docker.enable "docker")
      (mkIf config.virtualisation.podman.enable "podman")
      (mkIf config.virtualisation.libvirtd.enable "libvirtd")
      (mkIf config.virtualisation.virtualbox.host.enable "vboxusers")
      (mkIf config.programs.adb.enable "adbusers")
    ];
  };

  # doas
  mods.doas.enable = true;

  # sudo-rs
  # security.sudo.enable = false;
  # security.sudo-rs.enable = true;
  # security.sudo-rs.extraRules = [sudoRule];
  # or
  # security.sudo-rs.wheelNeedsPassword = false;

  # vanilla sudo
  # security.sudo.extraRules = [sudoRule];
  # or
  # security.sudo.wheelNeedsPassword = false;
}
