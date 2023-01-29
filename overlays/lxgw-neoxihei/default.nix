{ lib, fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neoxihei";
  version = "1.005";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-IvbbeBjpFz9zHt3mHu5vY8sLETKnvOMv7eHjANQ2GlA=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 ${src} -t $out/share/fonts/truetype/${pname}.ttf
  '';

  meta = with lib; {
    description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
