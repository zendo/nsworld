{
  config,
  pkgs,
  ...
}: {
  # Musnix enhence
  musnix.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Pipewire
  hardware.pulseaudio.enable = false; # false in pipewire
  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
