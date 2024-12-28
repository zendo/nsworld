{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.12.12-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "c3d861119e4c94790931ef25ff74f989aced1375";
    hash = "sha256-PxTc/MKoWcOMHegSVsjeKUzhrtD/ins90xVu4UUUUJI=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    rm -r ./others
    cp -r ./* $out/share/rime-data
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
