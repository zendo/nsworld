# { lib, fetchurl }:

# (fetchurl rec {
#   pname = "lxgw-neoxihei";
#   version = "1.003";

#   url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";

#   recursiveHash = true;
#   downloadToTemp = true;

#   hash = "sha256-6iuzA+3hou/jCzkoqg1rsOoAn8cngfzhT24jtw75YIA=";

#   meta = with lib; {
#     description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
#     homepage = "https://github.com/lxgw/LxgwNeoXiHei";
#     license = licenses.ipa;
#     platforms = platforms.all;
#     maintainers = with maintainers; [ zendo ];
#   };
# }).overrideAttrs (_: {
#   postFetch = ''
#     install -D $downloadedFile $out/share/fonts/truetype/LXGWNeoXiHei.ttf
#   '';
# })

{ lib, fetchurl, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "lxgw-neoxihei";
  version = "1.003";

  src = fetchurl {
    url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";
    hash = "sha256-bdMPyqsuJeMdZ+tzgfps6cIA642ttZC0L8OKxqOTju8=";
  };

  dontUnpack = true;

  installPhase = ''
    install -D $src -t $out/share/fonts/truetype/LXGWNeoXiHei.ttf
  '';

  meta = with lib; {
    description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
