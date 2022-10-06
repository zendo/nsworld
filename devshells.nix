inputs @ {pkgs}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      fd
      jq
      ripgrep
      gcc
      gnumake
      alejandra
      nixUnstable
      nix-direnv
    ];
  };

  # nix develop .#node
  node = pkgs.mkShell {
    buildInputs = with pkgs; [
      yarn
      nodejs
    ];
  };

  go = pkgs.mkShell {
    buildInputs = with pkgs; [
      go
      gccgo
      pkg-config
      alsa-lib
      flac
    ];
  };

  rust = pkgs.mkShell {
    buildInputs = with pkgs; [
      cargo
      rustc
      clang
      pkg-config
      xorg.libxcb
    ];
  };

  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
    ];
  };

  haskell = pkgs.mkShell {
    buildInputs = with pkgs; [
      ghc
      cabal-install
      haskell-language-server
    ];
  };
}
