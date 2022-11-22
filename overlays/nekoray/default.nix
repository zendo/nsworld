{ lib
, stdenv
  , fetchurl
, fetchFromGitHub
, cmake
, protobuf
, libyamlcpp
, zxing-cpp
, zxing
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
  version = "2.4";

  src = fetchFromGitHub {
    owner = "MatsuriDayo";
    repo = pname;
    rev = version;
    # rev = "27502477b9fa636a0d029fb528afcf66a7ca4ffd";
    fetchSubmodules = true;
    hash = "sha256-G+6ANSI+Vlc+cgcONrid9aFi+qX2JQI57jwVHb0ugtY=";
  };

  binTarball = fetchurl {
    url = "https://github.com/MatsuriDayo/nekoray/releases/download/${version}/nekoray-${version}-2022-11-15-linux64.zip";
    hash = "sha256-9GLOSowvAMS2+e3/5yowQw3GyYgId6+3sVYRhXroEYQ=";
  };

  nativeBuildInputs = [
    cmake
    qtbase
    qttools
    qtx11extras
    # wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    protobuf
    libyamlcpp
    zxing-cpp
    zxing
  ];

  cmakeFlags = [
    "-DNKR_NO_EXTERNAL=zxing"   # need zxing-cpp 1.3.0
    # "-DNKR_PACKAGE=true" # ?
  ];

  dontWrapQtApps = true;

  # still need a lot of work
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/nekoray
    cp -r * $out/share/nekoray
    install -Dm755 nekoray $out/bin/$pname
    runHook postInstall
  '';

  meta = with lib; {
    description = "Qt based cross-platform GUI proxy configuration manager (backend: v2ray / sing-box)";
    homepage = "https://github.com/MatsuriDayo/nekoray";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
