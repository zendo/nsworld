inputs @ { pkgs }: {

  #######################################################################
  ##  Stdenv
  #######################################################################
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      gcc
      gnumake
      cmake
      meson
      ninja
      pkg-config
      boost

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
    shellHook = ''
      zsh && exit
    '';
  };

  #######################################################################
  ##  NodeJS
  #######################################################################
  nodejs = pkgs.mkShell {
    buildInputs = with pkgs; [
      yarn
      nodejs
      electron

      # cargo-tauri
      # cargo
      # rustc
      # openssl
      # pkg-config
      # glib
      # libsoup
      # webkitgtk
    ];
    # ELECTRON_OVERRIDE_DIST_PATH = "${pkgs.electron_20}/bin";
  };

  #######################################################################
  ##  Golang
  #######################################################################
  go = pkgs.mkShell {
    buildInputs = with pkgs; [
      go
      gotools
      gccgo
      delve
      pkg-config
      alsa-lib
      flac
    ];
  };

  #######################################################################
  ##  Rust
  #######################################################################
  rust = pkgs.mkShell {
    doCheck = false;
    buildType = "debug";
    # OPENSSL_NO_VENDOR = 1;
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

      gtk4
      glib
      libadwaita
      wrapGAppsHook4
      appstream-glib
      desktop-file-utils
      libxml2
      dbus

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly

      alsa-lib
      lame
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

  #######################################################################
  ##  Python
  #######################################################################
  # python setup.py install --root=/home/iab/devs/
  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python3
      virtualenv
      python3Packages.pip
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

  #######################################################################
  ##  Java
  #######################################################################
  java = pkgs.mkShell {
    buildInputs = with pkgs; [
      jdk
      gradle
      xorg.libXrender
    ];
  };

  #######################################################################
  ##  Haskell
  #######################################################################
  haskell = pkgs.mkShell {
    buildInputs = with pkgs; [
      ghc
      stack
      cabal-install
      haskell-language-server
    ];
  };
}
