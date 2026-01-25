{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jhentai";
  version = "8.0.10+305";

  src = fetchurl {
    url = "https://github.com/jiangtian616/JHenTai/releases/download/v8.0.10%2B305/JHenTai-${finalAttrs.version}-Linux-x64.deb";
    hash = "sha256-q5ozA4NXzYAi8Hy+fHu6Iq1YoZm8w/4frfcGkwDJoA8=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
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
