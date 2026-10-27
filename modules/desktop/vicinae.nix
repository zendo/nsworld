{
  flake.modules.nixos.vicinae = { pkgs, ... }: {
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
