/*
  nix run ~/nsworld#fhs-run ./app

  # https://nixmultiverse.com/
  nix-build ~/nsworld/pkgs/fhs-run/package.nix --arg pkgs \
    'import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz") {}'
    'import (fetchTarball "https://nixos.org/channels/nixos-unstable-small/nixexprs.tar.xz") {}'
  ./result/bin/fhs-run ./app

  https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/appimage/default.nix#L112
*/
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.buildFHSEnv {
  name = "fhs-run";
  runScript = pkgs.writeShellScript "fhs-run" ''
    if [ $# -eq 0 ]; then
      echo "Usage: fhs-run command-to-run args..." >&2
      exit 1
    fi

    # Detect AppImages by filename or magic bytes.
    appimage=
    case "$1" in
      *.AppImage | *.appimage)
        appimage=1
        ;;
    *)
      case "$(od -An -tx1 -j 8 -N 3 "$1" 2>/dev/null | tr -d ' \n')" in
      414901 | 414902)
        appimage=1
        ;;
      esac
      ;;
    esac

    if [ -n "$appimage" ]; then
      # Extract AppImages instead of mounting them; allow environment overrides.
      export APPIMAGE_EXTRACT_AND_RUN="''${APPIMAGE_EXTRACT_AND_RUN:-1}"
      # Preload the host Wayland library to avoid symbol conflicts with the bundled copy.
      export LD_PRELOAD="/usr/lib64/libwayland-client.so.0''${LD_PRELOAD:+:$LD_PRELOAD}"
      # export __EGL_VENDOR_LIBRARY_DIRS="/run/opengl-driver/share/glvnd/egl_vendor.d''${__EGL_VENDOR_LIBRARY_DIRS:+:$__EGL_VENDOR_LIBRARY_DIRS}"
      # export LIBGL_DRIVERS_PATH="/run/opengl-driver/lib/dri''${LIBGL_DRIVERS_PATH:+:$LIBGL_DRIVERS_PATH}"
      # export LIBVA_DRIVERS_PATH="/run/opengl-driver/lib/dri''${LIBVA_DRIVERS_PATH:+:$LIBVA_DRIVERS_PATH}"
    fi

    exec "$@"
  '';
  targetPkgs =
    p: with p; [
      # --- base: expected by nearly every binary (AppImage excludelist) ------
      glib # libglib-2.0/libgobject/libgio
      zlib # libz
      bzip2 # libbz2
      xz # liblzma
      expat
      openssl # libssl/libcrypto
      curlMinimal # libcurl.so.4 (TLS yes; no idn/psl/brotli/zstd/http3, use `curl` for those)
      libkrb5 # libkrb5/libgssapi_krb5
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
      gmp # libgmp.so.10
      brotli # libbrotli{common,dec,enc}
      libgcrypt # libgcrypt.so.20
      libgpg-error # libgpg-error.so.0
      p11-kit # /etc/pkcs11 + libp11-kit + p11-kit-proxy
      libidn2
      libidn
      iana-etc # /etc/protocols, /etc/services

      # --- GTK / GLib stack -------------------------------------------------
      # runtime deps of cairo/pango/gdk-pixbuf are not pulled in automatically
      gtk3
      gdk-pixbuf # loaders dlopen the image libs below
      atk
      at-spi2-atk # GTK accessibility, dlopened
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
      libtiff # libtiff.so.6
      libwebp # libwebp.so.7 + libwebpdemux (gdk-pixbuf, Electron)
      librsvg # librsvg-2.so.2 (gdk-pixbuf svg loader)
      gsettings-desktop-schemas # GTK apps abort on missing schemas
      hicolor-icon-theme
      shared-mime-info # glib mime type lookups
      libsoup_3
      webkitgtk_4_1 # ±826 MiB of the whole closure, drop if nothing embeds a web view

      # --- X11 --------------------------------------------------------------
      libx11
      libxcb
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
      xkeyboard-config # /usr/share/X11/xkb data, needed by libxkbcommon

      # --- Wayland ----------------------------------------------------------
      wayland
      libxkbcommon
      libdecor

      # --- OpenGL / Vulkan --------------------------------------------------
      libGL # libglvnd: libGL/libEGL/libGLX/libOpenGL
      libdrm # runtime dep of libgbm/libGL, must be present for AppImages
      libgbm
      vulkan-loader # libvulkan.so.1; ICDs come from /run/opengl-driver
      # libGLU
      # libvdpau

      # --- Audio / Video ----------------------------------------------------
      alsa-lib
      pipewire # libpipewire-0.3 + Wayland screencast
      libpulseaudio # libpulse.so.0 - pipewire does NOT provide it
      # pulseaudio
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
      # gst_all_1.gstreamer # webkit/Electron media backend
      # gst_all_1.gst-plugins-base
      # gst_all_1.gst-plugins-ugly

      # --- SDL (games) ------------------------------------------------------
      # SDL2
      # SDL2_image
      # SDL2_mixer
      # SDL2_ttf

      # --- commonly dlopen()ed helpers --------------------------------------
      libsecret # Electron safeStorage/keytar
      libnotify # libnotify.so.4
      libxml2
      libxcrypt # libcrypt.so.1, legacy binaries

      # --- legacy, for parity with nixpkgs' AppImage list -------------------
      # glew_1_10 # libGLEW.so.1.10
      # freeglut # libglut.so.3
      # libcaca # libcaca.so.0
      # dbus-glib # libdbus-glib-1.so.2
      # libtool.lib # libltdl.so.7
      # libmikmod # libmikmod.so.3
      # pciutils # libpci.so.3
      # libpciaccess # libpciaccess.so.0
      # libpng12 # libpng12.so.0, very old apps only
      # onetbb # libtbb.so.12
      # curlWithGnuTls # libcurl-gnutls.so.4

      # --- tools (not libraries) --------------------------------------------
      xdg-utils # xdg-open
      xdg-user-dirs
      desktop-file-utils
      pax-utils # lddtree
      zenity
      chafa
    ];
}
