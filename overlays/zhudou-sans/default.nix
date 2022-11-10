{ lib, fetchzip }:

# https://github.com/NixOS/nixpkgs/pull/175381
fetchzip rec {
  pname = "zhudou-sans";
  version = "1.000";

  url = "https://github.com/Buernia/Zhudou-Sans/archive/refs/tags/v${version}.tar.gz";
  hash = "sha256-DFTK+eKhfRCbOrgTBlJeLD5Mdi0VYwullbo2poaLIKw=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    install -Dm644 "$out/fonts/variable ttf/Zhudou Sans-VF.ttf" $out/share/fonts/truetype
    install -Dm644 $out/fonts/ttf/*.ttf  $out/share/fonts/truetype

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';


  meta = with lib; {
    description = "A font family for CJK symbols and punctuation, derived from Noto Sans";
    homepage = "https://github.com/Buernia/Zhudou-Sans";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
