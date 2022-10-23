{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "adi1090x-plymouth-themes";
  version = "unstable-2021-07-12";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    hash = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
  };

  installPhase = ''
    # find . -type f -iname "*.plymouth" -exec sed -i -e "s/usr\/share/etc/g" {} \;
    find . -type f -name '*.plymouth' | xargs sed -i "s@usr/share@etc@g"
    mkdir -p $out/share/plymouth/themes
    cp -r ./pack_1/* $out/share/plymouth/themes
    cp -r ./pack_2/* $out/share/plymouth/themes
  '';

  meta = with lib; {
    description = "A hugh collection (80+) of plymouth themes ported from android bootanimations";
    homepage = "https://github.com/adi1090x/plymouth-themes";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
