{ ... }:
{
  services.openssh = {
    enable = true;
    # settings.PasswordAuthentication = lib.mkDefault false;
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
