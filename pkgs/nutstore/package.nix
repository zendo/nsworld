# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=nutstore
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  alsa-lib,
  atk,
  cairo,
  glib,
  glib-networking,
  gobject-introspection,
  gtk3,
  libGL,
  libX11,
  libXext,
  libXi,
  libXrender,
  libXtst,
  libayatana-appindicator,
  libnotify,
  procps,
  python3,
  webkitgtk_4_1,
  zlib,
}:

let
  # The tray and the desktop notifications live in the Python side of the
  # client, so it needs PyGObject at run time. Without it the daemon falls back
  # to the SWT tray, which shows nothing under Plasma/GNOME Wayland.
  pythonEnv = python3.withPackages (ps: [ ps.pygobject3 ]);

  # SWT, the embedded WebKit and the JNI helpers are unpacked from the jar into
  # a temp directory and dlopen'd at run time, so autoPatchelfHook never sees
  # them. They carry no RUNPATH either, so their direct NEEDED entries have to
  # be reachable here; everything those libraries pull in (Pango, HarfBuzz,
  # GdkPixbuf, ...) comes along gtk3's own RUNPATH.
  swtLibs = [
    atk
    cairo
    glib
    gtk3
    libGL
    libayatana-appindicator
    libnotify
    stdenv.cc.cc.lib
    webkitgtk_4_1
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nutstore";
  version = "6.4.3";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://pkg-cdn.jianguoyun.com/static/exe/st/${finalAttrs.version}/nutstore_client-${finalAttrs.version}-linux-x86_64-public.tar.gz";
    hash = "sha256-sG3NrWTP1joKztkNddzz8x1xPVg9qZIKlKI7tIw/2xI=";
  };

  # The archive has no top-level directory, so unpack it somewhere private:
  # copying the build root's own bookkeeping into $out would pull the whole
  # build closure in as runtime references.
  unpackPhase = ''
    mkdir source
    tar xf $src -C source
  '';
  sourceRoot = "source";

  nativeBuildInputs = [
    autoPatchelfHook
    gobject-introspection
    makeWrapper
    wrapGAppsHook3
  ];

  # Beyond swtLibs: what the bundled binaries link against directly (the
  # jpackage launcher needs libz, libjsound alsa, libawt_xawt the X11 libs), and
  # glib-networking, whose GIO module gives GLib a real TLS backend.
  # wrapGAppsHook3 only picks up what is a build input, hence the list here.
  buildInputs = [
    alsa-lib
    glib-networking
    libX11
    libXext
    libXi
    libXrender
    libXtst
    zlib
  ]
  ++ swtLibs;

  # The launcher, the bundled JRE and the JNI libraries in lib/native are
  # prebuilt amd64 binaries; only their external dependencies are missing.
  dontBuild = true;
  dontStrip = true;
  doCheck = false;

  # Known limitation, not a packaging bug: the daemon forces GDK_BACKEND=x11
  # because SWT has no Wayland backend, and SWT's own XDND handling ignores the
  # drags KWin synthesizes for native-Wayland sources. Dropping a folder into
  # the window therefore works from an X11/XWayland file manager but does
  # nothing from a native-Wayland one.

  installPhase = ''
    runHook preInstall

    # The daemon resolves everything relative to its own path: it refuses to
    # start unless it sits in <...>/bin, and expects jre/, lib/, conf/ and res/
    # beside it. So the tree stays intact instead of being split across $out.
    nutstore=$out/lib/nutstore
    install -d "$nutstore"
    cp -a . "$nutstore"

    # The "Auto Start Nutstore" checkbox belongs to the java client, which looks
    # for its autostart entry under ~/.nutstore/dist; hand it a writable copy
    # there on every start, the way the AUR package's launcher does.
    makeShellWrapper ${pythonEnv}/bin/python3 $out/bin/nutstore \
      --add-flags "$nutstore/bin/nutstore-pydaemon.py" \
      --prefix PATH : ${
        lib.makeBinPath [
          glib
          procps
        ]
      } \
      --set PYTHONWARNINGS ignore::DeprecationWarning \
      --run 'install -CDm644 ${placeholder "out"}/lib/nutstore/gnome-config/autostart/nutstore-daemon.desktop "$HOME/.nutstore/dist/gnome-config/autostart/nutstore-daemon.desktop" 2>/dev/null || true' \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath swtLibs}

    substituteInPlace "$nutstore/gnome-config/autostart/nutstore-daemon.desktop" \
      --replace-fail 'exec ~/.nutstore/dist/bin/nutstore-pydaemon.py' \
      'exec nutstore'

    substituteInPlace "$nutstore/gnome-config/menu/nutstore-menu.desktop" \
      --replace-fail 'Exec=sh -c "exec ~/.nutstore/dist/bin/nutstore-pydaemon.py"' \
      'Exec=nutstore'

    install -Dm644 "$nutstore/gnome-config/menu/nutstore-menu.desktop" \
      $out/share/applications/nutstore.desktop

    install -Dm644 app-icon/nutstore.png \
      $out/share/icons/hicolor/512x512/apps/nutstore.png

    runHook postInstall
  '';

  meta = {
    description = "Cloud storage and file sync client (Nutstore / 坚果云)";
    homepage = "https://www.jianguoyun.com/";
    license = lib.licenses.mit; # fake license
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nutstore";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
})
