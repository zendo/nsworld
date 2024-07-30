{ lib, config, ... }:
{
  # Using PipeWire as the sound server conflicts with PulseAudio
  hardware.pulseaudio.enable = lib.mkForce false;

  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

  # PipeWire is a relatively new low-level multimedia framework.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };
}
