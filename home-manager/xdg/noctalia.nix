{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  # https://docs.noctalia.dev/docs/
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };
}
