inputs @ {pkgs}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      jq
      gnumake
      alejandra
      nixUnstable
    ];
  };

  # nix develop .#node
  node = pkgs.mkShell {
    buildInputs = with pkgs; [
      nodejs
      yarn
    ];
  };

  rust = pkgs.mkShell {
    buildInputs = with pkgs; [cargo];
  };

  haskell = pkgs.mkShell {
    buildInputs = with pkgs; [
      ghc
      cabal-install
      haskell-language-server
    ];
  };
}
