{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.12.12-unstable-2025-02-02";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "84f99f21cd1c7c93f708e4dab5db3171d2e6f602";
    hash = "sha256-+oPCl9tmcBrbsAL3cZkSR9v7CxYMAaSJLwmp3eUjAlA=";
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
