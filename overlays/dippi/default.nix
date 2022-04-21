{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  glib,
  gtk3,
  pantheon,
  libhandy,
  desktop-file-utils,
  appstream-glib,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "dippi";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "dippi";
    rev = "${version}";
    sha256 = "sha256-huwMxGN7p3aB/4w8UfKQQ1KU0+YMRHkDvNyArWPzokM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    pantheon.granite
    libhandy
  ];

  meta = with lib; {
    homepage = "https://github.com/cassidyjames/dippi";
    description = "Calculate display info like DPI and aspect ratio";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
