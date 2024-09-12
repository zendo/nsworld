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
    rev = "1a3a57d067595f1dafbb73364811bc6c787441e7";
    hash = "sha256-ta77Aw1Z0JZO3VRcAio7Kv/gGve2XPQTTflTm8ZYf34=";
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
