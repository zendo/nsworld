{
  imports = [
    ./pkgs.nix
    ./cli.nix
    ./gui.nix
  ];

  home.stateVersion = "21.11";
  home.username = "iab";
  home.homeDirectory = "/home/iab";

  programs.home-manager.enable = true;
}
