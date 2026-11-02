{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {
      services.suwayomi-server = {
        # https://github.com/NixOS/nixpkgs/pull/560397
        # dataDir = lib.mkDefault "/data/media/manga";
        # openFirewall = config.networking.firewall.enable; # 由 Caddy 反代,不再直接放行
        settings = {
          server = {
            ip = "127.0.0.1";
            port = config.myVars.ports.suwayomi;
            extensionRepos = [
              "https://github.com/keiyoushi/extensions/tree/repo"
            ];
          };
        };
      };
    };
}
