{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  python3,
  gobject-introspection,
  json-glib,
}:

stdenv.mkDerivation rec {
  pname = "libipuz";
  version = "unstable-2022-07-31";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = pname;
    rev = "98975162a2bf8ba23371788b39c106209ddff032";
    sha256 = "sha256-sej8yQbAyadzJ7ydsTRN9CiDXCMMht5CQTf5Sek0BYk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    glib # for glib-mkenums needed during the build
    gobject-introspection
  ];

  buildInputs = [
    json-glib
  ];

  meta = with lib; {
    description = "Library for parsing ipuz files, for crossword puzzles, sudokus, etc";
    homepage = "https://gitlab.gnome.org/jrb/libipuz";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
