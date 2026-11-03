{
  flake.modules.nixos.services =
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
        wantedBy = [ "pipewire.service" ];
        # pw-dump/pw-metadata/pw-play from pipewire, wpctl from wireplumber,
        # and ffmpeg for the in-daemon A/B tuner (Clip::from_sample).
        path = [
          pkgs.pipewire
          pkgs.wireplumber
          # pkgs.ffmpeg-headless
        ];
        serviceConfig = {
          ExecStart = "${pkgs.neiro}/bin/neiro daemon";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
}
