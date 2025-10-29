{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
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
  webkitgtk_4_1,
  libsoup_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anich";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/Sle2p/AniCh/releases/download/${finalAttrs.version}/anich-linux-${finalAttrs.version}.deb";
    hash = "sha256-5Fwj0O3nBUjACr1xR/hhVw3Al+vMhxoJunMDtPEixlk=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
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
    webkitgtk_4_1
    libsoup_3
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/share $out
    ln -s $out/share/anich/anich $out/bin
  '';

  meta = {
    description = "(Anime Channel) 一个支持超分辨率的在线动漫弹幕APP";
    homepage = "https://github.com/Sle2p/AniCh";
    mainProgram = "anich";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit; # unknown
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})
