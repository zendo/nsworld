{ ... }:
{
  programs.dms-shell = {
    enable = true;
  };

  # include fonts:
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/display-managers/dms-greeter.nix#L210
  services.displayManager.dms-greeter = {
    # enable = true;
  };

  # programs.dsearch.enable = true;
}
