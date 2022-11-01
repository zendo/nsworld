{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, wrapQtAppsHook
, qtgraphicaleffects
, qtquickcontrols2
, qtx11extras
, qtwayland
, wayland
, mpv
, ffmpeg-full
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "bitwave";
  version = "0.2.4dev";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "BitWave";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Mex6RSZLSBmWess5XR2jJ3TBfr/ZWNOsuKikTI/l0/g=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    # pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtgraphicaleffects
    qtquickcontrols2
    qtx11extras
    qtwayland
    wayland
    mpv
    ffmpeg-full
  ];

  # makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive" ];

  # cmakeFlags = [
  #   "QT5_ADD_TRANSLATION=${placeholder "out"}/share/onverseen/loc"
  # ];

  # postPatch = ''
  #   substituteInPlace src/whereiam.cpp \
  #     --replace "/usr" "Sout"
  # '';

  meta = with lib; {
    description = "Batch image converter and resizer";
    homepage = "https://github.com/Faster3ck/Converseen";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
