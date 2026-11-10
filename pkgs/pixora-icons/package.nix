{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixora-icons";
  version = "0-unstable-2026-11-03";

  src = fetchFromGitHub {
    owner = "tsora1603";
    repo = "pixora-icons";
    rev = "ea994cfa6dc9da1a468405d6bcb6aeffa80aa52e";
    hash = "sha256-S0/lgDth1+wIM5nj0NYRwu0H5DpV2+vyPuQZNJW3AEo=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a pixora pixora-dark pixora-accent $out/share/icons/
  '';

  meta = {
    description = "16-bit pixel art icon theme for Linux desktops";
    homepage = "https://github.com/tsora1603/pixora-icons";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
