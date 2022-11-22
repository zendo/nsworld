{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-easy-en";
  version = "2021-07-08";

  src = fetchFromGitHub {
    owner = "BlindingDark";
    repo = pname;
    rev = "956cdfbb3ef6ebcdb1955e843a93e5c7d2039c4f";
    hash = "sha256-L9/JRQdBwRGp686YDHAhWQs5szUGKx+FA9FU/OKhUCY=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp *.yaml $_
  '';

  meta = with lib; {
    description = "Easy English 英文输入法";
    homepage = "https://github.com/BlindingDark/rime-easy-en";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
