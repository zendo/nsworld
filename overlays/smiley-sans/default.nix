{ lib, fetchzip }:

fetchzip rec {
  pname = "smiley-sans";
  version = "1.0.0";

  url = "https://github.com/atelier-anchor/smiley-sans/releases/download/v${version}/smiley-sans-v${version}.zip";

  stripRoot=false;

  postFetch = ''
    mkdir -p $out/share/fonts/{truetype,woff2}
    cp $out/*{.ttf,.otf} $out/share/fonts/truetype
    cp $out/*.woff2 $out/share/fonts/woff2

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  hash = "sha256-hc64ynVUj2P5pRHvU8IbcMXy2tCeN+S4QkMG9hR7Hcc=";


  meta = with lib; {
    description = "得意黑 Smiley Sans：一款在人文观感和几何特征中寻找平衡的中文黑体";
    homepage = "https://github.com/atelier-anchor/smiley-sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
