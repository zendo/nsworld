# bug
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
  dbus,
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
  version = "22.7";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-1479xlPjET1x5y/6eah+IzKWgIdabUd42SfLqEHbqlE=";
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
    libadwaita
    gtksourceview5
  ];

  # https://gitlab.com/posidon_software/paper/-/issues/35
  postInstall = ''
    # substituteInPlace $out/share/applications/io.posidon.Paper.desktop \
    #     --replace 'Exec=io.posidon.Paper' 'Exec=bash -c "cd /home/iab; io.posidon.Paper"'
    # sed -i '/DBusActivatable=true/d' $out/share/applications/io.posidon.Paper.desktop
  '';

  meta = with lib; {
    homepage = "https://posidon.io/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
