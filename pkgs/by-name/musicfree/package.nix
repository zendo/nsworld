{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  nss,
  nspr,
  mesa,
  libdrm,
  alsa-lib,
  udev,
  libayatana-appindicator,
}:

# https://gitee.com/maotoumao/MusicFreePlugins/raw/master/plugins.json
stdenv.mkDerivation rec {
  pname = "musicfree";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/maotoumao/MusicFreeDesktop/releases/download/v${version}/MusicFree-${version}-linux-amd64.deb";
    hash = "sha256-pVeMa3L8eaT4BjXJ8Y0O/QW3u03V4Vk4q23SaInNCII=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    nss
    nspr
    mesa
    libdrm
    alsa-lib
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out

    runHook postInstall
  '';

  meta = {
    description = "Free music player";
    homepage = "https://github.com/maotoumao/MusicFreeDesktop";
    mainProgram = "musicfree";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
}
