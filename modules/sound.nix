{
  config,
  pkgs,
  lib,
  ...
}: {
  # Musnix enhence
  musnix.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Pipewire
  hardware.pulseaudio.enable = lib.mkForce false; # false in pipewire
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
