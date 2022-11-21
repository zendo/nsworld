{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-theme-astronaut";
  version = "2021-12-15";

  src = fetchFromGitHub {
    owner = "totoro-ghost";
    repo = "sddm-astronaut";
    rev = "c51be8952297cbcfdae09daecd93c42c89906e8a";
    hash = "sha256-xpZE1ouAdNzTKs8N5TiUnhh9Mu2hI9+pr571PxZRlM8=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/astronaut
    cp -a $src/* $_
  '';

  meta = with lib; {
    description = "A dark theme for SDDM";
    homepage = "https://github.com/totoro-ghost/sddm-astronaut";
    license = licenses.lgpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
