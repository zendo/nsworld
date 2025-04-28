{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2025.04.06-unstable-2025-04-27";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "7e2fb97667cc7cb1d82ac7a928abbb788b0fbafc";
    hash = "sha256-9mKKtU+H7i8SY7KTYxAiSa7EJJk5rdSUglXWAJvZyv0=";
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
