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
      atk
      krb5
      alsa-lib
      pipewire

      # [ GTK ]
      gtk3
      gdk-pixbuf
      cairo
      pango
      libsoup_3
      webkitgtk_4_1

      # [ OpenGL ]
      libGL
      libgbm

      # [ X11 ]
      libx11
      libxcb
      libSM
      libxext
      libxfixes
      libxrandr
      libxdamage
      libxcomposite

      # [ Wayland ]
      wayland
      libxkbcommon

      # [ Python ]
      # (python3.withPackages (
      #   py: with py; [
      #     pyyaml
      #   ]
      # ))

      # [ .NET ]
      # icu
      # libICE

      # [ Tools ]
      pax-utils # lddtree
      zenity
      chafa
    ];
}
