{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixora-icons";
  version = "0-unstable-2026-11-20";

  src = fetchFromGitHub {
    owner = "tsora1603";
    repo = "pixora-icons";
    rev = "4b3ba3616e128a893730d85dcbf0227f61699d0c";
    hash = "sha256-HbGzGEXp1cHbMl7uKm744eCXGibRx1bB6npeLqziW0o=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a pixora pixora-dark pixora-accent $out/share/icons/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "16-bit pixel art icon theme for Linux desktops";
    homepage = "https://github.com/tsora1603/pixora-icons";
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
