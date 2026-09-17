{
  flake.modules.nixos.vicinae = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vicinae ];

    systemd.packages = [ pkgs.vicinae ];

    systemd.user.services.vicinae = {
      wantedBy = [ "graphical-session.target" ];
    };
  };

  flake.modules.homeManager.vicinae = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      # vicinae config default | wl-copy
      # settings = {
      # };
    };
  };
}
