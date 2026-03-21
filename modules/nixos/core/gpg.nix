{
  flake.modules.nixos.core =
    { ... }:
    {
      programs.gnupg.agent = {
        # enable = true;
        enableSSHSupport = true;
      };
    };
}
