{ lib, fetchurl }:

fetchurl rec {
  pname = "lxgw-neoxihei";
  version = "1.0";

  url = "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v${version}/LXGWNeoXiHei.ttf";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/LXGWNeoXiHei.ttf
  '';

  hash = "sha256-XPYYL/uhVEyB9EEoHh4VPCKDeKB8e5m2jAO8EdZmILs=";

  meta = with lib; {
    description = "A Simplified Chinese sans-serif font derived from IPAex Gothic";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
