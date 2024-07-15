{ lib, config, ... }:
{
  # Pipewire
  hardware.pulseaudio.enable = lib.mkForce false; # false in pipewire

  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
}
