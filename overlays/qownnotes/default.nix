{ lib, stdenv, fetchFromGitHub
, qmake, qttools, qtbase, qtsvg, qtdeclarative, qtxmlpatterns, qtwebsockets
, qtx11extras, qtwayland, cmake, qttranslations
}:

stdenv.mkDerivation rec {
  pname = "qownnotes";
  version = "22.11.4";

  src = fetchFromGitHub {
    owner = "pbek";
    repo = "QOwnNotes";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-hZtkG8y5lzrS6KQxKzEIgKWA2xCHVvQcZxdrbujne+U=";
  };

  nativeBuildInputs = [ cmake #qttools
                      ];

  buildInputs = [
    qtbase
    qtsvg
    qtdeclarative
    qtxmlpatterns
    qtwebsockets
    qtx11extras
    qttranslations
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # "-DQT_TRANSLATIONS_DIR=${qttranslations}/translations"
    "-DQT_TRANSLATIONS_DIR=share/qt5/translations"
  ];

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    license = licenses.gpl2Only;
    mainProgram = "QOwnNotes";
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.linux;
  };
}
