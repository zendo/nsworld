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
  multiverse,
}:
let
  onnxruntime = multiverse.versions.onnxruntime."1.22.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "venerax";
  version = "2.3.6";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Kyosee/VeneraX/releases/download/v${finalAttrs.version}/VeneraX-${finalAttrs.version}-amd64.deb";
    hash = "sha256-90k30+JqS0dHd+a0mD4Zb10gBd9IT242Ewv67URj3PE=";
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
    onnxruntime
    (lib.getLib stdenv.cc.cc)
  ];

  autoPatchelfIgnoreMissingDeps = [ "libjvm.so" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
    rm -f $out/local/lib/venera/lib/libonnxruntime.so
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
    homepage = "https://github.com/Kyosee/VeneraX";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "venera";
  };
})
