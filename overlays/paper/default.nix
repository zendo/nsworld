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
  version = "22.9";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = version;
    # rev = "a95850b04caee2e747b546e4e34e297321bd3532";
    sha256 = "sha256-IU/5RKRX6QxKnq7lUC8z73su1s54MLQdUTXxb3GePWg=";
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
  # postInstall = ''
  #   # substituteInPlace $out/share/applications/io.posidon.Paper.desktop \
  #   #     --replace 'Exec=io.posidon.Paper' 'Exec=bash -c "cd /home/iab; io.posidon.Paper"'
  #   # sed -i '/DBusActivatable=true/d' $out/share/applications/io.posidon.Paper.desktop
  # '';

  meta = with lib; {
    description = "A pretty markdown note-taking app for Gnome";
    homepage = "https://posidon.io/paper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
