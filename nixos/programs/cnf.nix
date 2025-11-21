{ inputs, ... }:
{
  programs.command-not-found = {
    # enable = true;
    dbPath = inputs.nixpkgs + "/programs.sqlite";
  };
}
