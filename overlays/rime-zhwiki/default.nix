{ lib
, fetchurl
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-zhwiki";
  version = "0.2.4";

  src = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20221029.dict.yaml";
    hash = "sha256-aO2uWD0Tb+EDTWwOA1BoPhZI4h1d9ljJzujtAxtQ1fo=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp $src $out/share/rime-data/zhwiki.dict.yaml
  '';

  meta = with lib; {
    description = "Fcitx 5 Pinyin Dictionary from zh.wikipedia.org";
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
