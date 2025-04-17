{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2025.04.06-unstable-2025-04-16";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "5b1999c3c3bc1bfd84bffacd7ff5c5e0879ea683";
    hash = "sha256-7DodE2/bcYSVoXCyJ9YAeYH80lARIG7XJ9AImh75Kcc=";
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
