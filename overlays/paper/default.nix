{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  meson,
  ninja,
  vala,
  pkg-config,
  cmake,
  libgee,
  glib,
  gtk4,
  libadwaita,
  gtksourceview5,
  appstream-glib,
  wrapGAppsHook4,
}:
stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.1";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = "paper";
    rev = "2b472c30cabf24ad74e89a30ad309640a31d1aef";
    sha256 = "sha256-mxBk8X02C2N8MXLcZC5EffDB5qXF/rndUNNwmLWormE=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    vala
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libgee
    gtksourceview5
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/posidon_software/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
