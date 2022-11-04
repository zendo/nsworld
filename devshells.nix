inputs @ {pkgs}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      gcc
      gnumake
      cmake
      meson
      ninja
      pkg-config
      qt5.qtbase
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
    OPENSSL_NO_VENDOR = 1;
    buildInputs = with pkgs; [
      cargo
      rustc
      meson
      ninja
      clang
      openssl
      pkg-config
      curl
      # gtk4
      # glib
      # libadwaita
      # wrapGAppsHook4
      # appstream-glib
      # desktop-file-utils
      # libxml2
      # xorg.libxcb
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
