{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

# nix-update --flake --version=branch rime-ice
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024.09.25-unstable-2024-11-04";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "a022f0943fedf71eae154e1f06cad64079a3f536";
    hash = "sha256-nLuR4rfza0Tjjh28e51ZNzgVXUo9GpClMOrl5Do0+iw=";
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
