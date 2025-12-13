{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.mods.nixos-diff.enable = lib.mkEnableOption "diff configuration on activation";

  config = lib.mkIf config.mods.nixos-diff.enable {
    # Copy: https://github.com/thiagokokada/nix-configs/blob/master/modules/nixos/nix/diff.nix
    # system.activationScripts.diff = ''
    #   export PATH="${lib.makeBinPath [ config.nix.package ]}:$PATH"
    #   if [[ -e '/run/current-system' ]]; then
    #     echo "showing changes compared to /run/current-system..."
    #     ${lib.getExe pkgs.dix} '/run/current-system' "$systemConfig" || true
    #   fi
    # '';

    # Copy: https://github.com/nix-community/srvos/blob/main/shared/common/update-diff.nix
    system.preSwitchChecks.update-diff = ''
      incoming="''${1-}"
      if [[ -e /run/current-system && -e "''${incoming-}" ]]; then
        echo "--- diff to current-system"
        ${lib.getExe pkgs.dix} /run/current-system "''${incoming-}"
        echo "---"
      fi
    '';
  };
}
