# wip
#  ERROR: Dependency "webkit2gtk-5.0" not found, tried pkgconfig and cmake
{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  cmake,
  sqlite,
  webkitgtk,
  # libgee,
  glib,
  gtk4,
  # gtksourceview5,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "notes";
  version = "unstable-2022-04-29";

  src = fetchFromGitHub {
    owner = "Blquinn";
    repo = pname;
    rev = "fed1d49ba2a3ec9b932247b2aeff8cf5422fc4d3";
    sha256 = "sha256-Wsl1AOJNM1IwdlxkYF4vL8uObJl+IlVzDEmjUQ2o1QY=";
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
    sqlite
    # libgee
    libadwaita
    webkitgtk
    # gtksourceview5
  ];

   configureFlags = ["--with-webkit2gtk-4-0"];

  meta = with lib; {
    homepage = "https://gitlab.com/posidon_software/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
