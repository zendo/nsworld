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
    rev = "bc2acf7d2e861047f32454ced13d8977975e2a92";
    hash = "sha256-iyJ0Ais6u2JNyapC+ypcNiamYSsuLbtOlAprm5ZrL6g=";
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
