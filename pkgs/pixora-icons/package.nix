{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixora-icons";
  version = "0-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "tsora1603";
    repo = "pixora-icons";
    rev = "ad4163987d959d5a6cbdee7ec330986ba2a8df8e";
    hash = "sha256-zXEmg9aOnAvZY4AA2cpfShXvcdlx6Hd0pab68MMLno4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a pixora pixora-dark pixora-accent $out/share/icons/

    runHook postInstall
  '';

  meta = {
    description = "16-bit pixel art icon theme for Linux desktops";
    homepage = "https://github.com/tsora1603/pixora-icons";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
