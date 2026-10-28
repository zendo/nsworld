{
  flake.modules.nixos.selfhosted =
    { config, ... }:
    {

      services.suwayomi-server = {
        # https://github.com/NixOS/nixpkgs/pull/560397
        # dataDir = "/data/media/manga";
        openFirewall = config.networking.firewall.enable;
        settings = {
          server = {
            ip = "0.0.0.0";
            port = 1238;
            extensionRepos = [
              "https://github.com/keiyoushi/extensions/tree/repo"
            ];
          };
        };
      };

    };
}
