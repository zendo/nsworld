{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "zhudou-sans";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/Buernia/Zhudou-Sans/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-GmKnxpsAWN2AQg+17vcdyo1h/GaNNW5Tk+d9KRZfQ/U=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.ttf' -exec install -Dm644 -t $out/share/fonts/truetype {} \;

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
