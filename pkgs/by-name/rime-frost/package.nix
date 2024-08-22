{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-frost";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "gaboolic";
    repo = "rime-frost";
    rev = "${finalAttrs.version}";
    hash = "sha256-+BhPKQupXT+kTiYEYMkBldmI0oZpoB/5G1cCpdF34w4=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r ./* $_
  '';

  meta = {
    description = "基于雾凇拼音重制的，更纯净、词频准确、智能的词库";
    downloadPage = "https://github.com/gaboolic/rime-frost";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
