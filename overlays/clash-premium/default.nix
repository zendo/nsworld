{ fetchurl, stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "clash-premium";
  version = "2023.01.29";

  src = fetchurl {
    url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-2023.01.29.gz";
    hash = "sha256-LCN9HNBZZ1oAIeLxm/NnMdnD5Hrw1STgisXOUdSYPaY=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/clash-premium.gz
    gzip --decompress $out/bin/clash-premium.gz
    chmod +x $out/bin/clash-premium
  '';

  meta = with lib; {
    homepage = https://github.com/Dreamacro/clash;
    description = "Close-sourced pre-built Clash binary with TUN support and more";
    # license = licenses.unfree;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yinfeng ];
  };
}
