{ lib
, stdenv
, fetchFromGitHub
, cmake
, protobuf
, libyamlcpp
, zxing-cpp
, wrapQtAppsHook
, qtbase
, qtx11extras
, qttools
, qtsvg
}:
# WIP!!!
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=nekoray
stdenv.mkDerivation rec {
  pname = "nekoray";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "MatsuriDayo";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-9yPFn7zqYX+fVGqDJsdeVxZfw7bTT8Ve1VLmq/Rrsk4=";
  };

  nativeBuildInputs = [
    cmake
    qtbase
    qttools
    qtx11extras
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    protobuf
    libyamlcpp
    zxing-cpp
  ];

  meta = with lib; {
    description = "Qt based cross-platform GUI proxy configuration manager (backend: v2ray / sing-box)";
    homepage = "https://github.com/MatsuriDayo/nekoray";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
