{ config, ... }:
{
  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

  # PipeWire is a relatively new low-level multimedia framework.
  services.pipewire = {
    # alsa.support32Bit = true;
    # jack.enable = true;
  };
}
