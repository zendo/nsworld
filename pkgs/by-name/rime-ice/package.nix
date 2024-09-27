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
    rev = "ea74e40bec2bd6580fa8d807075cd107739ba6cd";
    hash = "sha256-R2K2LNycXqsUxXvMMq5fcQJUhDnhQMcTlvryMLeiKH0=";
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
