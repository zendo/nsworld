{ lib
, stdenv
, fetchFromGitLab
, vala
, meson
, ninja
, pkg-config
, glib
, gtk4
, dbus
, libgee
, librsvg
, libadwaita
, gtksourceview5
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.999";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    # rev = version;
    rev = "a15ffe2ff3c6ff5223a00e89106b5d1ae08d5702";
    hash = "sha256-7WoF8obmSQvElzKA80eoL+X2bdEnrV8151jgjNi1dt0=";
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
    dbus
    libgee
    librsvg
    libadwaita
    gtksourceview5
  ];

  # postInstall = ''
  #   substituteInPlace $out/share/dbus-1/services/io.posidon.Paper.SearchProvider.service \
  #       --replace 'io.posidon.Paper.SearchProvider' $out/bin/paper-search-provider
  # '';

  meta = with lib; {
    description = "A pretty markdown note-taking app for Gnome";
    homepage = "https://posidon.io/paper";
    mainProgram = "io.posidon.Paper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
