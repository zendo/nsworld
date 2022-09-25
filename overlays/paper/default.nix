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
let
  # require 'libadwaita-1', version: '>= 1.2.alpha'
  libadwaita-git = libadwaita.overrideAttrs (oldAttrs: rec {
    version = "1.2.0";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = version;
      hash = "sha256-3lH7Vi9M8k+GSrCpvruRpLrIpMoOakKbcJlaAc/FK+U=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.999";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    # rev = version;
    rev = "c9756467ad9c56ea7714c89ebd1f1a884ea7d837";
    hash = "sha256-T7jF9bpOgZqZlp2jWaj//3QpEpaAsJP4a9zjgpevHjU=";
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
    libadwaita-git
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
