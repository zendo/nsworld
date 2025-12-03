{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  libgbm,
  nss,
  nspr,
  musl,
  vips,
  alsa-lib,
  libpulseaudio,
  libdrm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amethyst";
  version = "2.1.7";

  src = fetchurl {
    url = "https://github.com/Geoxor/Amethyst/releases/download/v${finalAttrs.version}/amethyst_${finalAttrs.version}_amd64.deb";
    hash = "sha256-N00wV4l0qroa2P3+gVaQsYH4b6D8EhAkg7Tw9ExDIlg=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    libgbm
    nss
    nspr
    musl
    vips
    alsa-lib
    libpulseaudio
    # libdrm
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    cp -r usr/* $out
    ln -s $out/opt/Amethyst/amethyst $out/bin
    substituteInPlace $out/share/applications/amethyst.desktop \
      --replace-fail 'Exec=/opt/Amethyst/amethyst %U' 'Exec=amethyst %U'
  '';

  meta = {
    description = "Cross-platform audio player with a node-based audio routing system";
    homepage = "https://amethyst.geoxor.moe/overview";
    downloadPage = "https://github.com/Geoxor/amethyst";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "amethyst";
  };
})
