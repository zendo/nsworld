{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.12.12-unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "5c7f123cf36f2f485bf600a6a8c667b1bd1b1e0d";
    hash = "sha256-3sqMm5iSKianpHCpedEtvc7Hf1wdiZXqAqdpm8HkEp8=";
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
