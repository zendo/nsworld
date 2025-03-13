{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.12.12-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "75b225e84f5e95ddf0b5a50fa6e2cff9800ee7b7";
    hash = "sha256-/sKoufIf4m5h1Zds6AqIyeCjDaZsFU9ot5ln3ykuNyU=";
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
