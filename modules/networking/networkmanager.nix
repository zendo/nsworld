{
  flake.modules.nixos.networkmanager =
    { ... }:
    {
      networking.networkmanager = {
        enable = true; # conflict with `networking.wireless`
        # dns = "none"; # for Transparent Proxy
        wifi.backend = "iwd"; # replace "wpa_supplicant"
      };
    };
}
