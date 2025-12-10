{ ... }:
{
  # shell history
  # atuin login -u zendo
  # atuin sync -f
  programs.atuin = {
    enable = true;
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
}
