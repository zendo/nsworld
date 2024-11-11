{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

# update an unstable package to the latest commit of the default branch
# nix-update --flake --version=branch rime-ice
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.09.25-unstable-2024-11-09";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "9a2a217bf57f53212b114aa7c0a702e4d8b55519";
    hash = "sha256-OyaOriiyIMRsZz59LyOS/LtG1J4DU02NHcaJ6PdaffU=";
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
