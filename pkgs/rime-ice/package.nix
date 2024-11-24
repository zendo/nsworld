{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.09.25-unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "c68d2780dc022058a0fdd0357be66eaaa8216f72";
    hash = "sha256-R6WtyA0LhonNi+LECculCsXqIW2UyXJNQ5D8jnYvpa0=";
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
