{ alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, dpkg
, expat
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, gtk4
, lib
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libdrm
, libnotify
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, nss
, pango
, stdenv
, systemd
, at-spi2-atk
, at-spi2-core
, makeWrapper
, autoPatchelfHook
, wrapGAppsHook
, qt5
, proprietaryCodecs ? false
, vivaldi-ffmpeg-codecs
, pipewire
, wayland
, libglvnd
, libGLU
, libGL
}:

let
  mirror = "https://get.geo.opera.com/pub/opera/desktop";
in
stdenv.mkDerivation rec {
  pname = "opera";
  version = "94.0.4606.54";

  src = fetchurl {
    url = "${mirror}/${version}/linux/${pname}-stable_${version}_amd64.deb";
    hash = "sha256-IMWIkJHKaE7n5Rll4ZExE6PQB9a2fz0hLx4vckbROgk=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    wrapGAppsHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libnotify
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    # pipewire
    stdenv.cc.cc.lib
    # wayland
    # libGLU
    # libGL
    # libglvnd
  ];

  runtimeDependencies = [
    # Works fine without this except there is no sound.
    libpulseaudio.out

    # This is a little tricky. Without it the app starts then crashes. Then it
    # brings up the crash report, which also crashes. `strace -f` hints at a
    # missing libudev.so.0.
    (lib.getLib systemd)

    # (lib.getLib curl)

    # Error at startup:
    # "Illegal instruction (core dumped)"
    gtk3
    gtk4
  ] ++ lib.optional proprietaryCodecs [
    vivaldi-ffmpeg-codecs
  ];

  dontWrapQtApps = true;

  # SharedImageBackingFactory error:
  # --disable-gpu-memory-buffer-video-frames

  # Wayland
  # --enable-features=UseOzonePlatform --ozone-platform=wayland


  installPhase = ''
    mkdir -p $out/bin
    cp -r usr $out
    cp -r usr/share $out/share
    ln -s $out/usr/bin/opera $out/bin/opera

    # makeWrapper $out/usr/bin/${pname} $out/bin/${pname} \
    #   --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc  ] }"
    #   # --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=UseOzonePlatform}}"
  '';

  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=UseOzonePlatform}}"
  #   )
  # '';

  meta = with lib; {
    homepage = "https://www.opera.com";
    description = "Faster, safer and smarter web browser";
    platforms = [ "x86_64-linux" ];
    # license = licenses.unfree;
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
