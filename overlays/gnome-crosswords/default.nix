{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  glib,
  gtk4,
  librsvg,
  libipuz,
  json-glib,
  libadwaita,
  gobject-introspection,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:

let
  # require 'libadwaita-1', version: '>= 1.2.alpha'
  libadwaita-git = libadwaita.overrideAttrs (oldAttrs: rec {
    version = "1.2.alpha";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = version;
      hash = "sha256-JMxUeIOUPp9k5pImQqWLVkQ2GHaKvopvg6ol9pvA+Bk=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "gnome-crosswords";
  version = "0.3.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "crosswords";
    rev = version;
    sha256 = "sha256-w2wlAx9/C2AEm5ls3gsfiXeifOjKxBHbV0f8if44Ebk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libipuz
    json-glib
    libadwaita-git
  ];

  meta = with lib; {
    description = "A crossword player and editor for GNOME";
    homepage = "https://gitlab.gnome.org/jrb/crosswords";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
