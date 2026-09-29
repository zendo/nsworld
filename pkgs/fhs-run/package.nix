{
  pkgs ? import <nixpkgs> { },
}:

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/appimage/default.nix#L112
pkgs.buildFHSEnv {
  name = "fhs-run";
  runScript = pkgs.writeShellScript "fhs-run" ''
    if [ $# -eq 0 ]; then
      echo "Usage: fhs-run command-to-run args..." >&2
      exit 1
    fi

    exec "$@"
  '';
  targetPkgs =
    p: with p; [
      libgcc.lib
      fontconfig.lib
      glib
      zlib
      nss
      nspr
      cups
      pcre2
      dbus
      udev
      openssl
      expat
      curlMinimal
      libkrb5
      # krb5

      # [ GTK ]
      glib
      gtk3
      gdk-pixbuf
      atk
      cairo
      pango
      libsoup_3
      webkitgtk_4_1

      # [ OpenGL ]
      libGL
      libgbm
      # vulkan-loader

      # [ X11 ]
      libx11
      libxcb
      libSM
      libICE
      libxext
      libxfixes
      libxdamage
      libxcomposite
      libxkbcommon
      libxrandr
      libxrender
      libxcursor
      libxi
      libxtst
      libxinerama
      libxscrnsaver

      # [ Wayland ]
      wayland
      libxkbcommon

      # [ Audio ]
      alsa-lib
      pipewire

      # [ Python ]
      # (python3.withPackages (
      #   py: with py; [
      #     pyyaml
      #   ]
      # ))

      # [ .NET ]
      # icu

      # [ Tools ]
      pax-utils # lddtree
      zenity
      chafa
    ];
}
