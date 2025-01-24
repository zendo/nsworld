{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.12.12-unstable-2025-01-20";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "2284f72a3da64187647457ced4c50b46c893434b";
    hash = "sha256-EUIQQTQpV6tvUThzPWps0WBKld8jawPgaDa90QKKCuM=";
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
