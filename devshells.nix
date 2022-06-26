inputs @ {pkgs}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      fd
      ripgrep
      jq
      gnumake
      alejandra
      nixUnstable
      nix-direnv
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
