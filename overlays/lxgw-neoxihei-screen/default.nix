{ lib, fetchurl }:

fetchurl rec {
  pname = "lxgw-neoxihei-screen";
  version = "1.0";

  url = "https://github.com/lxgw/LxgwNeoXiHei-Screen/releases/download/v${version}/LXGWNeoXiHeiScreen.ttf";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/LXGWNeoXiHeiScreen.ttf
  '';

  hash = "sha256-XOW3Yj83pTFy22yFTXeLxwuMnokdsMu0AoCITiXEC6g=";

  meta = with lib; {
    description = "LXGW Neo XiHei for Screen Reading";
    homepage = "https://github.com/lxgw/LxgwNeoXiHei-Screen";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
