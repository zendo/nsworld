{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  nss,
  nspr,
  alsa-lib,
  openssl,
  webkitgtk,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.0.9";

  src = fetchurl {
    url = "https://github.com/pompurin404/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-amd64.deb";
    hash = "sha256-O3ZsPMSHKauuGGN1SCVp0tXWwxzW9K3eFshEZ+HN9EQ=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/mihomo-party usr/share $out
    ln -s $out/mihomo-party/mihomo-party $out/bin

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace '/opt/mihomo-party/mihomo-party' 'mihomo-party'

    runHook postInstall
  '';

  meta = {
    description = "Another Mihomo GUI";
    homepage = "https://github.com/pompurin404/mihomo-party";
    mainProgram = "mihomo-party";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
}
