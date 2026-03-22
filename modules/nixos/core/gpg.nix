{
  flake.modules.nixos.gpg =
    { ... }:
    {
      programs.gnupg.agent = {
        # enable = true;
        enableSSHSupport = true;
      };
    };
}
