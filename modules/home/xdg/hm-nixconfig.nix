{ config, ... }:
{
  nix.extraOptions = ''
    !include ${config.sops.secrets."access_tokens".path}
  '';
}
