{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  gobject-introspection,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "frog";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = version;
    sha256 = "sha256-RGyj7Hnl9wvlA9HGvPJIuDqKNmshMgm6lswqCUGK00I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    homepage = "https://github.com/TenderOwl/Frog";
    description = "Extract text from any image, video, QR Code and etc";
    maintainers = with maintainers; [zendo];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
