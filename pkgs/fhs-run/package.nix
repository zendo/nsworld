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
      pcre2
      openssl
      curlMinimal
      krb5

      # [ GTK ]
      gtk3
      gdk-pixbuf
      cairo
      libsoup_3
      webkitgtk_4_1

      # [ OpenGL ]
      libGL

      # [ X11 ]
      libx11
      libxcb
      libSM

      # [ Wayland ]
      wayland
      libxkbcommon

      # [ Python ]
      # (python3.withPackages (
      #   p: with p; [
      #     pyyaml
      #   ]
      # ))

      # [ .NET ]
      # icu
      # libICE

      # [ Tools ]
      pax-utils # lddtree
      zenity
    ];
}
