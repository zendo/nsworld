{
  lib,
  stdenv,
  fetchFromGitLab,
  vala,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk4,
  libgee,
  libadwaita,
  gtksourceview5,
  blueprint-compiler,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.6";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-rutN91CFpGyRufG8VIhGjK5704D5mQ5Sn+jfm6BG0po=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libadwaita
    gtksourceview5
  ];

  meta = with lib; {
    homepage = "https://posidon.io/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
