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

  # sudo rule
  # security.sudo.execWheelOnly = true;

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
        (mkIf config.virtualisation.incus.enable "incus-admin")
        (mkIf config.virtualisation.virtualbox.host.enable "vboxusers")
        (mkIf config.programs.adb.enable "adbusers")
      ];
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };

    users.guest = {
      isNormalUser = true;
      # pw: guest
      initialHashedPassword = "$y$j9T$oznNwtFAUKqaYFuvQPnA0/$Etrip7WsJhPV64kBsW61fO.MUgB50eEJeUpXCA48cxC";
    };
  };

  # Workaround for userborn: Generate subuid/subgid files from the user configuration
  # https://github.com/nikstur/userborn/issues/7
  system.activationScripts.podman-subid =
    let
      user = config.users.users.${myvars.user};
      subuidContent = lib.concatMapStrings (
        range: "${myvars.user}:${toString range.startUid}:${toString range.count}\n"
      ) user.subUidRanges;
      subgidContent = lib.concatMapStrings (
        range: "${myvars.user}:${toString range.startGid}:${toString range.count}\n"
      ) user.subGidRanges;
    in
    {
      text = ''
        if [ -L /etc/subuid ]; then rm /etc/subuid; fi
        if [ -L /etc/subgid ]; then rm /etc/subgid; fi
        cp -f ${pkgs.writeText "subuid" subuidContent} /etc/subuid
        cp -f ${pkgs.writeText "subgid" subgidContent} /etc/subgid
        chmod 644 /etc/subuid /etc/subgid
      '';
    };
}
