{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  udev,
  libgbm,
  cups,
  nss,
  nspr,
  alsa-lib,
  libdrm,
  xorg,
  mpv-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "anich";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/Sle2p/AniCh/releases/download/${version}/anich-linux-${version}.deb";
    hash = "sha256-jV3xa3D2eNLFZOPrNl7TVJQDoHRCupcQbPkEnk/yAe8=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libgbm
    cups
    nss
    nspr
    alsa-lib
    libdrm
    xorg.libXv
    mpv-unwrapped
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/share $out
    ln -s $out/share/ani/ani $out/bin
  '';

  meta = {
    description = "(Anime Channel) 一个支持超分辨率的在线动漫弹幕APP";
    homepage = "https://github.com/Sle2p/AniCh";
    mainProgram = "ani";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit; # unknown
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
}
