{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  libgcc,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "venerax";
  version = "3.0.3";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Kyosee/VeneraX/releases/download/v${finalAttrs.version}/VeneraX-${finalAttrs.version}-amd64.deb";
    hash = "sha256-f14etEzLwj2otk2ktriU2pBYhxgoEigQf6YX3T26J1o=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc.lib
    webkitgtk_4_1
    glib-networking
    libayatana-appindicator
  ];

  autoPatchelfIgnoreMissingDeps = [ "libjvm.so" ];

  # The payload lives under $out/local, which stripDebugList does not cover.
  stripAllList = [ "local" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a usr/. $out/
    ln -s $out/local/lib/venera/venera $out/bin

    install -Dm644 $out/share/icons/venera.png $out/share/icons/hicolor/512x512/apps/venera.png
    rm $out/share/icons/venera.png

    substituteInPlace $out/share/applications/venera.desktop \
      --replace-fail "/usr/local/lib/venera/venera" "venera"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/local/lib/venera/lib"
    )
  '';

  meta = {
    description = "Comic reader that support reading local and network comics";
    homepage = "https://github.com/Kyosee/VeneraX";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "venera";
  };
})
