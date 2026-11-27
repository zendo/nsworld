{
  # https://nixos.org/channels/nixos-unstable-small/nixexprs.tar.xz
  # pkgs ?
  #   import
  #     (fetchTarball "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz")
  #     { },
  pkgs ? import <nixpkgs> { },
  # https://nixmultiverse.com/
  multiverse ? null,
}:
let
  # buildFHSEnv hard-codes `glibcLocales` (every locale, 222 MiB) into its base
  # paths. Merge a trimmed copy into the package set it builds from: a plain
  # attrset merge rather than `pkgs.extend`, because extending changes the
  # fixpoint and stdenv with it, which rebuilds everything that uses stdenv.
  fhsPkgs =
    pkgs
    // {
      glibcLocales = pkgs.glibcLocales.override {
        allLocales = false;
        # nix eval .#nixosConfigurations.yoga.config.i18n.supportedLocales
        locales = [
          "C.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
          "zh_CN.UTF-8/UTF-8"
        ];
      };
    }
    // {
      pkgs = fhsPkgs;
      pkgsHostTarget = fhsPkgs;
    };
  fhsCallPackage = pkgs.lib.callPackageWith fhsPkgs;
  buildFHSEnv = fhsCallPackage "${pkgs.path}/pkgs/build-support/build-fhsenv-bubblewrap/default.nix" {
    callPackage = fhsCallPackage;
  };
in
buildFHSEnv {
  name = "fhs-run";
  runScript = pkgs.replaceVarsWith {
    src = ./fhs-run.sh;
    isExecutable = true;
    replacements.glib_networking = pkgs.glib-networking;
  };
  targetPkgs =
    p: with p; [
      # --- base: expected by nearly every binary (AppImage excludelist) ----
      glib # libglib-2.0/libgobject/libgio
      zlib # libz
      bzip2 # libbz2
      # bzip2.out # libbz2.so.1
      xz # liblzma
      zstd
      expat
      # getLib pins the library output, otherwise meta.outputsToInstall drags the
      # man pages (45 MiB) and CLI tools of these into the runtime rootfs.
      (p.lib.getLib p.openssl) # libssl/libcrypto
      curlMinimal # libcurl.so.4 (TLS yes; no idn/psl/brotli/zstd/http3, use `curl` for those)
      libkrb5 # libkrb5/libgssapi_krb5
      libepoxy
      pcre2 # libpcre2-8 (glib)
      dbus
      udev # libudev.so.1
      nss # Chromium/Electron: libnss3/libsmime3/libnssutil3
      nspr # libnspr4
      cups # libcups.so.2
      util-linux # libuuid.so.1, libblkid, libmount, libfdisk - dlopened very often
      e2fsprogs # libcom_err.so.2, libext2fs, libe2p, libss
      keyutils.lib # libkeyutils.so.1
      libcap # libcap.so.2, libpsx.so.2
      libusb1 # libusb-1.0.so.0
      sqlite
      gmp # libgmp.so.10
      brotli # libbrotli{common,dec,enc}
      lz4 # liblz4.so.1 (libarchive, ffmpeg)
      (p.lib.getLib p.libbsd) # libbsd.so.0 (libmpv/ffmpeg)
      libffi # libffi.so.8, dlopened/used by many binaries
      libgcrypt # libgcrypt.so.20
      libgpg-error # libgpg-error.so.0
      p11-kit # /etc/pkcs11 + libp11-kit + p11-kit-proxy
      libidn2
      libidn
      iana-etc # /etc/protocols, /etc/services

      # --- GTK / GLib stack ------------------------------------------------
      gtk4 # 30.7 MiB
      libadwaita
      graphene
      # poppler # optional: PDF rendering, only document apps
      # gtksourceview5 # optional: source editor widget, rare outside GNOME editor apps
      gtk3 # 42.0 MiB
      gdk-pixbuf # loaders dlopen the image libs below
      atk
      cairo
      pango
      harfbuzz
      fribidi
      libthai
      pixman # libpixman-1.so.0 (cairo)
      freetype # libfreetype.so.6 (fontconfig/pango)
      fontconfig.lib # libfontconfig; /etc/fonts is bind mounted from the host
      libpng # libpng16.so.16
      libjpeg # libjpeg.so.62 (gdk-pixbuf jpeg loader, chafa)
      # libjpeg8 # optional: legacy libjpeg.so.8; most apps use libjpeg.so.62
      libtiff # libtiff.so.6
      libwebp # libwebp.so.7 + libwebpdemux (gdk-pixbuf, Electron)
      librsvg # 15.7 MiB; librsvg-2.so.2 (gdk-pixbuf svg loader)
      gsettings-desktop-schemas # GTK apps abort on missing schemas
      hicolor-icon-theme
      adwaita-icon-theme
      shared-mime-info # glib mime type lookups
      libsoup_3
      libproxy
      webkitgtk_4_1 # 175.6 MiB
      # webkitgtk_6_0
      glib-networking
      # cacert
      libayatana-appindicator

      # --- KDE -------------------------------------------------------------
      qt6.qtbase # 86.6 MiB
      qt6.qtsvg
      # qt6.qtwayland
      # qt6.qtdeclarative # libQt6QuickControls2.so.6
      # qt6.qtmultimedia
      # kdePackages.mpvqt # libMpvQt.so.4
      # kdePackages.qtpositioning
      # kdePackages.kirigami.unwrapped
      # kdePackages.kcoreaddons
      # kdePackages.knotifications

      # --- X11 -------------------------------------------------------------
      (p.lib.getLib p.libx11)
      (p.lib.getLib p.libxcb)
      libxcb-util
      libxcb-wm # libxcb-ewmh/icccm
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libSM
      libICE
      libxext
      libxfixes
      libxdamage
      libxcomposite
      libxrandr
      libxrender
      libxcursor
      libxi
      libxtst
      libxinerama
      libxscrnsaver
      libxxf86vm
      libxft
      libxt
      libxmu
      xkeyboard-config # 10.3 MiB; /usr/share/X11/xkb data, needed by libxkbcommon

      # --- Wayland ---------------------------------------------------------
      wayland
      libxkbcommon
      libdecor

      # --- OpenGL / Vulkan -------------------------------------------------
      libGL # libglvnd: libGL/libEGL/libGLX/libOpenGL
      libdrm # runtime dep of libgbm/libGL, must be present for AppImages
      libgbm
      vulkan-loader # libvulkan.so.1; ICDs come from /run/opengl-driver
      libGLU # old mesa
      # libvdpau

      # --- Audio / Video ---------------------------------------------------
      alsa-lib # libasound.so.2
      libpulseaudio # libpulse.so.0 - pipewire does NOT provide it
      # pipewire # 16.9 MiB; libpipewire-0.3 + Wayland screencast
      # pulseaudio
      # wireplumber
      # libjack2
      # libcanberra
      # flac
      # libogg
      # libvorbis
      # libvpx
      # libtheora
      # speex
      # libsamplerate
      # libmpg123
      # libcdio
      # lcms2
      # libarchive
      # libva
      # libxv
      # libvdpau
      # ffmpeg-headless
      # mpv-unwrapped # optional: libmpv, heavy; only media apps
      gst_all_1.gstreamer # webkit/Electron media backend
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      # gst_all_1.gst-plugins-ugly
      # gst_all_1.gst-plugins-bad
      # gst_all_1.gst-plugins-rs

      # --- SDL (games) -----------------------------------------------------
      # SDL2
      # SDL2_image
      # SDL2_mixer
      # SDL2_ttf
      # jdk_headless
      # icu

      # --- Windows Emulator -------------------------------------------------
      # wimlib
      # hivex
      # spdlog
      # fmt
      # libvncserver
      # libvirt
      # libisofs

      # --- commonly dlopen()ed helpers -------------------------------------
      libsecret # Electron safeStorage/keytar
      libnotify # libnotify.so.4
      libxml2
      libxcrypt # libcrypt.so.1, legacy binaries

      # --- tools (not libraries) -------------------------------------------
      appimageTools.appimage-exec # unpacks AppImages into the fhs-run cache
      xdg-utils # xdg-open
      xdg-user-dirs
      desktop-file-utils
      # pax-utils # lddtree
      zenity
      # xdotool
      # chafa # optional: CLI image viewer tool, not a runtime dependency
    ];
}
