{ lib
, stdenv
, fetchFromGitHub
, qmake
, wrapQtAppsHook
, qtbase
, qtsvg
, qttools
, qtdeclarative
, qtwayland
, wayland
, zxing-cpp
, zxing
, xorg
, qtquickcontrols2
  , kwidgetsaddons
}:
# WIP!!!
# https://github.com/archlinuxcn/repo/blob/master/archlinuxcn/v2ray-desktop/PKGBUILD
#
stdenv.mkDerivation rec {
  pname = "v2ray-desktop";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "Dr-Incognito";
    repo = "V2Ray-Desktop";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-PlaHBU/BG6jtJo+WB1ZZyYtfHKaKnU/9VAvYcnWWzd8=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    kwidgetsaddons
    qtquickcontrols2
    qtdeclarative
    qtwayland
    wayland

    # zxing-cpp
    # zxing
    xorg.libX11
    # xorg.libXinerama
  ];

  qmakeFlags = [
    # "PREFIX=${placeholder "out"}"
    "src/V2Ray-Desktop.pro"
  ];

  postPatch = ''
    substituteInPlace src/V2Ray-Desktop.pro \
      --replace "opt" "$out"
  '';

  meta = with lib; {
    description = "A cross-platform GUI proxy client that supports Shadowsocks, V2Ray, and Trojan protocols";
    homepage = "https://github.com/Dr-Incognito/V2Ray-Desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
