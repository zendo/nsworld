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

      # qt5.qtbase
      # qt5.qttools
      # qt5.qtx11extras
      # qt5.wrapQtAppsHook
      # qt5.qtsvg
      # protobuf
      # libyamlcpp
      # zxing-cpp
      # zxing
      # xorg.libX11
      # xorg.libXi
      # xorg.libXinerama
    ];
  };

  node = pkgs.mkShell {
    buildInputs = with pkgs; [
      yarn
      nodejs
    ];
    # ELECTRON_OVERRIDE_DIST_PATH = "${pkgs.electron_20}/bin";
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
      cmake
      # gtk4
      # glib
      # libadwaita
      # wrapGAppsHook4
      # appstream-glib
      # desktop-file-utils
      # libxml2
      alsa-lib
      # libxkbcommon
      # xorg.libX11
      # xorg.libxcb
      # xorg.xcbutil
      # xorg.xcbutilwm
      # xorg.xcbutilimage
      # xorg.xcbutilkeysyms
      # freetype
      # fontconfig
    ];
  };

  # python setup.py install --root=/home/iab/devs/
  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
    ];
    propagatedBuildInputs = with pkgs.python3.pkgs; [
      requests
      chardet
      docutils
      markdown
      markups
      pyenchant
      pygments
      # pyqt5
      # pyqt6
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
