{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2025.04.06-unstable-2025-05-25";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "904aedb7c2097309e4f5a9be29baf6ce5cc64415";
    hash = "sha256-a0b6k0dOwrdxCf+ZcX/fiF4K1LLGuEw5eBriRFkY2AI=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    rm -r ./others
    cp -r ./* $out/share/rime-data
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
