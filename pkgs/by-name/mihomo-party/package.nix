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
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/pompurin404/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-amd64.deb";
    hash = "sha256-yRH6jyRW9yYq2z02YIoZUKacGzjINdnMd3Ru0zMcFf4=";
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
      --replace-fail '/opt/mihomo-party/mihomo-party' 'mihomo-party'

    runHook postInstall
  '';

  postInstall = ''
    makeWrapper $out/mihomo-party/mihomo-party $out/bin/mihomo-party \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"
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
