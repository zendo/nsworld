{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024-08-09";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "0407f13bfd45e8ed82b7f26fe0c9642635184cb6";
    hash = "sha256-OnXznPdxilrvMP/d1T9v8VQ2PeZ9xLHQzmNfLJl2bnA=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r ./* $_
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
