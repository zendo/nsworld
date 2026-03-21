{ config, ... }:
{
  flake.modules.nixos.default.imports = with config.flake.modules.nixos; [
    core
    mods

    # [networking]
    dns
    firewall
    networkmanager
    # print

    programs
    services

    secrets
  ];
}
