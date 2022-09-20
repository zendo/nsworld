{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zhudou-sans";
  version = "1.000";

  src = fetchFromGitHub {
    owner = "Buernia";
    repo = "Zhudou-Sans";
    rev = "v${version}";
    hash = "sha256-GmKnxpsAWN2AQg+17vcdyo1h/GaNNW5Tk+d9KRZfQ/U=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 "fonts/variable ttf/Zhudou Sans-VF.ttf" $out/share/fonts/truetype
    install -Dm644 fonts/ttf/*  $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A font family for CJK symbols and punctuation, derived from Noto Sans";
    homepage = "https://github.com/Buernia/Zhudou-Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [zendo];
  };
}
