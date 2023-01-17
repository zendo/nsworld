{ lib, fetchurl }:

(fetchurl rec {
  pname = "lxgw-neoxihei";
  version = "1.003";

  url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";

  recursiveHash = true;
  downloadToTemp = true;

  hash = "sha256-6iuzA+3hou/jCzkoqg1rsOoAn8cngfzhT24jtw75YIA=";

  meta = with lib; {
    description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}).overrideAttrs (_: {
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/LXGWNeoXiHei.ttf
  '';
})
