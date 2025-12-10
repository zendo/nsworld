{
  lib,
  config,
  pkgs,
  myvars,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  # Declaratively users and groups
  services.userborn.enable = lib.mkDefault true;

  # sudo-rs
  security.sudo-rs.enable = true;

  # doas
  # security.sudo.enable = false;
  # security.doas.enable = true;
  # environment.systemPackages = [ pkgs.doas-sudo-shim ];

  users = {
    mutableUsers = lib.mkDefault false;

    users.root = {
      initialHashedPassword = "$y$j9T$ADp.JgagrVYSV4dPkJbKv/$INtu0eR/6.xYHzKlFmlTBWNFuAEkXnLMOU5hPYY8GM9";
      # copy ssh pub key to /etc/ssh/authorized_keys.d/root
      # or copy to ~/.ssh/authorized_keys
      # ssh-copy-id -i ~/.ssh/id_ed25519.pub aaa@192.168.122.85
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz linzway@qq.com"
      ];
    };

    users.${myvars.user} = {
      isNormalUser = true;
      # `mkpasswd`
      initialHashedPassword = "$y$j9T$aNhZV153pAbvGMeFqjGmn.$iH18jxovF5Huof8U4NNPK/EVWHH75o5x8lRzq8IHZO3";
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
        "video"
        (mkIf config.virtualisation.docker.enable "docker")
        (mkIf config.virtualisation.podman.enable "podman")
        (mkIf config.virtualisation.libvirtd.enable "libvirtd")
        (mkIf config.virtualisation.virtualbox.host.enable "vboxusers")
        (mkIf config.programs.adb.enable "adbusers")
      ];
    };

    users.guest = {
      isNormalUser = true;
      # pw: guest
      initialHashedPassword = "$y$j9T$oznNwtFAUKqaYFuvQPnA0/$Etrip7WsJhPV64kBsW61fO.MUgB50eEJeUpXCA48cxC";
    };
  };
}
