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
, xorg
}:
# WIP!!!
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=nekoray
stdenv.mkDerivation rec {
  pname = "nekoray";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "MatsuriDayo";
    repo = pname;
    # rev = version;
    rev = "fbffd4e6066660037a7d64389979d7c615faf248";
    fetchSubmodules = true;
    hash = "sha256-pxezOwiXtHT47e5MedzCO3S+u6SMTu26faXVohkpYlc=";
  };

  # binTarball = fetchurl {
  #   url = "https://github.com/MatsuriDayo/nekoray/releases/download/${version}/nekoray-${version}-2022-11-15-linux64.zip";
  #   hash = "sha256-9GLOSowvAMS2+e3/5yowQw3GyYgId6+3sVYRhXroEYQ=";
  # };

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
    xorg.libXinerama
  ];

  cmakeFlags = [
    # "-DNKR_NO_EXTERNAL=zxing" # need zxing-cpp 1.3.0
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
