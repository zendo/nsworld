{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kirigami2
, qtwebkit
, qtquickcontrols2
, wrapQtAppsHook
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
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kirigami2
    qtwebkit
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "A convergent markdown note taking application using Kirigami/QML";
    homepage = "https://gitlab.com/schul9louis/klever";
    license = with licenses; [ ];
    maintainers = with maintainers; [ zendo ];
  };
}
