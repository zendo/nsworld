# WIP
{ lib
, stdenv
, fetchFromGitHub
, qt5
# , wrapQtAppsHook
# , extra-cmake-modules
, cmake
, boost
# , nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "downzemall";
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "setvisible";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0IzPEHt6Gr32AMjlbVYm/ot+FuwdriAdM1iDP/awnKU=";
  };

  nativeBuildInputs = [
    cmake
    # extra-cmake-modules
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost
  ];

  # passthru.updateScript = nix-update-script {
    #   attrPath = pname;
    # };

    meta = with lib; {
      description = "A download manager for Windows, MacOS and Linux";
      homepage = "https://github.com/setvisible/DownZemAll";
      platforms = platforms.linux;
      license = with licenses; [ gpl3Plus ];
      maintainers = with maintainers; [ zendo ];
    };
}
