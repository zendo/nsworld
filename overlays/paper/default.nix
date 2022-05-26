# wip
{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  cmake,
  libgee,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.5";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-C7ZYs9kJaUCm4Nxb4lw2c4WQkyHQ6P8dfKNUgYLsSRI=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    cmake
    pkg-config
    appstream-glib
    desktop-file-utils
    wrapGAppsHook4
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
