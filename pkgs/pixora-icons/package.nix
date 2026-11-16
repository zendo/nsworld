{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixora-icons";
  version = "0-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "tsora1603";
    repo = "pixora-icons";
    rev = "5fa28ec084a74c2742adf3609b5b2d3ed79b9f05";
    hash = "sha256-WBojo7YufvjIjKSm2qevcM0NDAs/cTsySk8hm6pCtU0=";
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
