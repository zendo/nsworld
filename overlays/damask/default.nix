{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, vala
, pkg-config
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, json-glib
, libgee
, libsoup_3
, libadwaita
, libportal-gtk4
}:

stdenv.mkDerivation rec {
  pname = "damask";
  version = "0.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "subpop";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oen6vHWAa1HiXHTVe5BC22jnTt6NIhGBaSx3WJ/4zeM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    blueprint-compiler
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    json-glib
    libgee
    libsoup_3
    libadwaita
    libportal-gtk4
  ];

  meta = with lib; {
    description = "Automatically set wallpaper images from Internet sources";
    homepage = "https://gitlab.gnome.org/subpop/damask";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
