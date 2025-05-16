{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2025.04.06-unstable-2025-05-16";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "10053e774d22b64d1e4d169c041ef7d9224a6a33";
    hash = "sha256-A4GUoD3Ayc354vyMEevNprNfL/JAzSRp6Jk8yB4EnSY=";
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
