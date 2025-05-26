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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "algermusicplayer";
  version = "4.7.1";

  src = fetchurl {
    url = "https://github.com/algerkong/AlgerMusicPlayer/releases/download/v${finalAttrs.version}/AlgerMusicPlayer-${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-ewnI3VkovZjxyx4MbQDGYONBXA8rJiXKBguJUmfHmAI=";
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
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt usr/share $out
    ln -s $out/opt/AlgerMusicPlayer/algermusicplayer $out/bin/algermusicplayer

    substituteInPlace $out/share/applications/algermusicplayer.desktop \
      --replace-fail '/opt/AlgerMusicPlayer/algermusicplayer' 'algermusicplayer'
  '';

  meta = {
    description = "一个第三方音乐播放器、本地服务、桌面歌词、音乐下载、最高音质";
    homepage = "https://github.com/algerkong/AlgerMusicPlayer";
    mainProgram = "algermusicplayer";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit; # unknown
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})
