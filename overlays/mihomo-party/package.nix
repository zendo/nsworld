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
  webkitgtk_4_0,
  udev,
  libayatana-appindicator,
  libGL,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "mihomo-party";
  version = "1.5.6";

  src = fetchurl {
    url = "https://github.com/pompurin404/mihomo-party/releases/download/v${version}/mihomo-party-linux-${version}-amd64.deb";
    hash = "sha256-4ipAV9kqK/qYAydXMugDI4RbGe/a5Om+hKz/KwPXXSc=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    nspr
    alsa-lib
    openssl
    webkitgtk_4_0
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

  postFixup = ''
    wrapProgram "$out/bin/mihomo-party" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
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
