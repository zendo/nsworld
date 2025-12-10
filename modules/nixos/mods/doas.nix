{
  lib,
  pkgs,
  self,
  config,
  ...
}:
{
  options.mods.doas.enable = lib.mkEnableOption "doas customize.";

  config = lib.mkIf config.mods.doas.enable {
    security.sudo.enable = false;

    security.doas = {
      enable = true;
      # wheelNeedsPassword = false;
      # or
      extraRules = [
        {
          users = [ "${self.nixosConfigurations.yoga._module.specialArgs.myvars.user}" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };

    environment.systemPackages = [ pkgs.doas-sudo-shim ];

    environment.shellAliases = {
      sudoedit = "doas micro";
    };
  };
}
