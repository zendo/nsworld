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
    ];
  };

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
      delve
      pkg-config
      alsa-lib
      flac
    ];
  };

  rust = pkgs.mkShell {
    buildInputs = with pkgs; [
      cargo
      rustc
      meson
      ninja
      clang
      pkg-config
      gtk4
      glib
      libadwaita
      wrapGAppsHook4
      appstream-glib
      desktop-file-utils
      libxml2
      xorg.libxcb
      alsa-lib
    ];
  };

  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
    ];
  };

  java = pkgs.mkShell {
    buildInputs = with pkgs; [
      jdk
      gradle
      xorg.libXrender
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
