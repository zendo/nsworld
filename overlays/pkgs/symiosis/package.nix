{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  udev,
  libgbm,
  nss,
  libayatana-appindicator,
  webkitgtk_4_1,
  libsoup_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "symiosis";
  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/dathinaios/symiosis/releases/download/v${finalAttrs.version}/symiosis_${finalAttrs.version}_amd64.deb";
    hash = "sha256-Nd2Glb5UpsSpIfFU2aRWjt0V86dsC9NZAleOwTGAwTI=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libgbm
    nss
    webkitgtk_4_1
    libsoup_3
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    libayatana-appindicator
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Notational Velocity inspired notes app";
    homepage = "https://github.com/dathinaios/symiosis";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    license = lib.licenses.gpl2;
    mainProgram = "Symiosis";
  };
})
