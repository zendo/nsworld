{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-swish";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "icaho";
    repo = "Swish";
    rev = version;
    hash = "sha256-2q5cyk6v6eF+FORldFwnL2VJiqtKQoKbpOzY4aQAbfE=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/swish
    cp -a $src/* $_
  '';

  meta = with lib; {
    description = "Fantastic Sweet SDDM theme from Eliver Lara";
    homepage = "https://github.com/icaho/Swish";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
