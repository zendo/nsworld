{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qmake
, qtbase
, qttools
, qtsvg
, wrapQtAppsHook
, qtwayland
, zxing-cpp
, zxing
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "v2ray-desktop";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Dr-Incognito";
    repo = "V2Ray-Desktop";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-HV08aeT9+tQNSVUsTJ/S2zvl4AdhBO4U7dmTP0oqP44=";
  };

  nativeBuildInputs = [
    qmake
    qtbase
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    # qtwayland
    zxing-cpp
    # zxing
  ];

  qmakeFlags = [
    "src/V2Ray-Desktop.pro"
    "PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    substituteInPlace src/V2Ray-Desktop.pro \
      --replace "opt" "tmp"
  '';

  postInstall = ''
    cp -r ./* $out/include/
  '';

  # dontWrapQtApps = true;

  meta = with lib; {
    description = "The most elegant cross-platform proxy GUI client that supports Shadowsocks(R), V2Ray, and Trojan";
    homepage = "https://github.com/Dr-Incognito/V2Ray-Desktop";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
