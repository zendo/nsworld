{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "venera";
  version = "2.0.12";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Kyosee/venera/releases/download/v${finalAttrs.version}/venera_${finalAttrs.version}_amd64.deb";
    hash = "sha256-tOeeABdR0aUQC64p2gpEZ/f2/KP3Ymh1/a4ieqSFosM=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    libayatana-appindicator
    (lib.getLib stdenv.cc.cc)
  ];

  autoPatchelfIgnoreMissingDeps = [ "libjvm.so" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
    ln -s $out/local/lib/venera/venera $out/bin

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
    homepage = "https://github.com/Kyosee/venera";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "venera";
  };
})
