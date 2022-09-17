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
  version = "22.10";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = version;
    # rev = "a95850b04caee2e747b546e4e34e297321bd3532";
    hash = "sha256-XvRLsHszV834x4RpC4p+eb0cLkb+BNv9iXseXhvIQjY=";
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

  # postInstall = ''
  #   ln -s $out/bin/com.github.cassidyjames.dippi $out/bin/dippi
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
