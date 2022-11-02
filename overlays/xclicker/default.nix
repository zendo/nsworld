{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk3
, wrapGAppsHook
, xorg
}:

stdenv.mkDerivation rec {
  pname = "xclicker";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "robiot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f47V81fQcfR04PTkaj/yByH7CLXuu8CnMnjwpKZO2qE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtk3
    xorg.libXi
    xorg.libX11
    xorg.libXtst
  ];

  postInstall = ''
    install -Dm755 src/xclicker $out/bin/xclicker
    install -Dm444 $src/assets/xclicker.desktop -t $out/share/applications/
    install -Dm444 $src/assets/icon.png $out/share/icons/hicolor/256x256/apps/xclicker.png
    install -Dm444 $src/assets/xyz.xclicker.xclicker.metainfo.xml -t $out/share/metainfo/
  '';

  meta = with lib; {
    description = "A blazing fast gui autoclicker for x11 linux'";
    homepage = "https://github.com/robiot/xclicker";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
