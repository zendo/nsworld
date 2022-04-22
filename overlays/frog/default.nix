# WIP
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
python3.pkgs.buildPythonApplication rec {
  pname = "frog";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "TenderOwl";
    repo = "Frog";
    rev = version;
    sha256 = "sha256-RGyj7Hnl9wvlA9HGvPJIuDqKNmshMgm6lswqCUGK00I=";
  };

  # setup.py and pyproject.toml not found
  format = "other";

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

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  # postUnpack = ''
  # (
  # cd "$sourceRoot"
  # rm build-aux/meson/postinstall.py
  # )
  # '';


  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';


  # delete finnal line to stop exec postinstall.py
  # patchPhase = ''
  #   sed -i '$ d' meson.build
  # '';

  meta = with lib; {
    homepage = "https://github.com/TenderOwl/Frog";
    description = "Intuitive text extraction tool (OCR) for GNOME";
    maintainers = with maintainers; [zendo];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
