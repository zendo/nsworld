{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  webkitgtk_4_1,
  glib-networking,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jhentai";
  version = "8.0.11+306";

  src = fetchurl {
    url = "https://github.com/jiangtian616/JHenTai/releases/download/v8.0.11/JHenTai-8.0.11+306-Linux-x64.deb";
    hash = "sha256-tj8FPtm7S2+GPwe0AcwCYyW4ASrUZg7/XvgMbia+yTQ=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    cp -r usr/* $out
    ln -s $out/opt/jhentai/jhentai $out/bin
  '';

  meta = {
    description = "Cross-platform manga app";
    homepage = "https://github.com/jiangtian616/JHenTai";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "jhentai";
  };
})
