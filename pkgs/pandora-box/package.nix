{
  lib,
  stdenv,
  fetchurl,
  unzip,
  dpkg,
  wrapGAppsHook4,
  autoPatchelfHook,
  udev,
  libgbm,
  nss,
  alsa-lib,
  libayatana-appindicator,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pandora-box";
  version = "1.0.19";

  src = fetchurl {
    url = "https://github.com/snakem982/Pandora-Box/releases/download/v${finalAttrs.version}/linux-amd64-deb.zip";
    hash = "sha256-bk3kEui2SqNbUL/JPBrNMiSBgV6+1wPbYQVBYt7YzMA=";
  };

  nativeBuildInputs = [
    unzip
    dpkg
    wrapGAppsHook4
    autoPatchelfHook
  ];

  buildInputs = [
    libgbm
    nss
    alsa-lib
    webkitgtk_4_1
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    libayatana-appindicator
    (lib.getLib udev)
  ];

  unpackPhase = ''
    unzip $src
    dpkg --fsys-tarfile ./*.deb | tar --extract
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "lightweight and user-friendly cross-platform client for Mihomo";
    homepage = "https://github.com/snakem982/Pandora-Box";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pandora-box";
  };
})
