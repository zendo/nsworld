{
  flake.modules.nixos.mods =
    { lib, pkgs, ... }:
    {
      systemd.user.services.neiro = {
        enable = lib.mkDefault false;
        description = "neiro speaker enhancement (PipeWire DSP)";
        after = [
          "pipewire.service"
          "wireplumber.service"
        ];
        requires = [ "pipewire.service" ];
        wantedBy = [ "default.target" ];
        path = [ pkgs.pipewire ];
        serviceConfig = {
          ExecStart = "${pkgs.neiro}/bin/neiro daemon";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
}
