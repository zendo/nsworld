{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kirigami2
, qtwebkit
  , qtwebengine
, qtquickcontrols2
, wrapQtAppsHook
, qtbase
, qttools
, kcoreaddons
, pkg-config
, kconfig
  , ki18n
}:

stdenv.mkDerivation rec {
  pname = "klever";
  version = "unstable-2023-02-18";

  src = fetchFromGitLab {
    owner = "schul9louis";
    repo = "klever";
    rev = "f8c2eda7a8139ff46d61e05e5e9491d97e848d96";
    hash = "sha256-xqkAK6efBSnFgyyRK/9ZAX5QCFM3Q2Iq+tMJcyHeDzw=";
  };

  nativeBuildInputs = [
    cmake
    # pkg-config
    # qttools
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    # qtbase
    ki18n
    kconfig
    kcoreaddons
    kirigami2
    # qtwebkit
    qtwebengine
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "A convergent markdown note taking application using Kirigami/QML";
    homepage = "https://gitlab.com/schul9louis/klever";
    license = with licenses; [ ];
    maintainers = with maintainers; [ zendo ];
  };
}
