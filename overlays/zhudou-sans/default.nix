{ lib, fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "zhudou-sans";
  version = "1.000";

  src = fetchurl {
    url = "https://github.com/Buernia/Zhudou-Sans/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-AQ3yl2X+2Rtx0ocgfqfBZR6aw9eApWhKnK00/1zNdbQ=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;
    runHook postInstall
  '';

  meta = with lib; {
    description = "A font family for CJK symbols and punctuation, derived from Noto Sans";
    homepage = "https://github.com/Buernia/Zhudou-Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
