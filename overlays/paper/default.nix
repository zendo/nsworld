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
  version = "999";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    # rev = "${version}";
    rev = "0e7f1aac9d42b95c0d1648035eb3098f98525589";
    sha256 = "sha256-YyrT/xZNHIx4cqC2oKpt9R1pbEe6HzH6LyhB2VZm7Bg=";
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
    libgee
    libadwaita
    gtksourceview5
  ];

  # WIP: desktop seems wrong
  # postFixup = ''
  #   cd $out/share/applications/
  #   mv io.posidon.Paper.desktop temp
  #   mv io.posidon.Paper-editor.desktop io.posidon.Paper.desktop
  #   mv temp io.posidon.Paper-editor.desktop
  # '';

  meta = with lib; {
    homepage = "https://posidon.io/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
