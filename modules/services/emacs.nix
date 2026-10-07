{ inputs, ... }:
{
  flake.modules.nixos.emacs =
    { pkgs, config, ... }:
    {
      environment.systemPackages = with pkgs; [
        # vips # dirvish image
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrapper-emacs
      ];

      services.emacs = {
        # enable = true;
        package = pkgs.wrapper-emacs;
        defaultEditor = true;
        startWithGraphical = config.services.graphical-desktop.enable;
      };
    };
}
