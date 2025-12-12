{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  pango,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gravel";
  version = "0.8.4";

  src = fetchurl {
    url = "https://github.com/thorio/gravel/releases/download/v${finalAttrs.version}/gravel-debian-x86_64.deb";
    hash = "sha256-YHT6rz72HPPghRSEHFDfYzb5NNzksBH+iPJXdnq0uZ8=";
  };

  nativeBuildInputs = [
    dpkg
    # wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    pango
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXfixes
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Cross-platform application launcher for Linux and Windows";
    homepage = "https://github.com/thorio/gravel";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "gravel";
  };
})
