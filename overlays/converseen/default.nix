{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, imagemagick
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "converseen";
  version = "0.9.9.8";

  src = fetchFromGitHub {
    owner = "Faster3ck";
    repo = "Converseen";
    rev = "v${version}";
    hash = "sha256-gmr05g755Z8/h752FHLDdMRvAjPW5oLPqBmX72MYev0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    imagemagick
  ];

  # makeWrapperArgs = [ "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive" ];

  # cmakeFlags = [
  #   "QT5_ADD_TRANSLATION=${placeholder "out"}/share/onverseen/loc"
  # ];

  # postPatch = ''
  #   substituteInPlace src/whereiam.cpp \
  #     --replace "/usr" "Sout"
  # '';

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Batch image converter and resizer";
    homepage = "https://github.com/Faster3ck/Converseen";
    changelog = "https://github.com/Faster3ck/Converseen/releases/tag/${src.rev}";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
