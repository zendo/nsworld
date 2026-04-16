/*
  # [shell history]
  atuin login -u zendo
  atuin sync -f
*/
{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      enableBashIntegration = false;
      flags = [
        "--disable-up-arrow"
        # "--disable-ctrl-r"
      ];
      # settings = {
      #   auto_sync = true;
      #   sync_frequency = "5m";
      #   sync_address = "https://api.atuin.sh";
      #   search_mode = "prefix";
      # };
    };
  };
}
