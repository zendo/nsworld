{ config, ... }:

{
  users.users.iab = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$Ucz3KNxCw0qXEhyH$RO/k0hjSKGNdImlNlRIoPw6KOCPXAq3QgLoNlIXkELvPGuPgHjW.FXpqrV6413gw74L05U05LkCR1ZTdNFtGC1";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}
