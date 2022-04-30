# wip
# https://gitlab.gnome.org/World/design/app-icon-preview
{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  cmake,
  pkg-config,
  glib,
  gtk4,
  libxml2,
  gdk-pixbuf,
  libadwaita,
  rustPlatform,
  wrapGAppsHook4,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "app-icon-preview";
  version = "3.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = pname;
    rev = version;
    sha256 = "sha256-3rTgMiHOiPUn25T2Otsqqe5wPE/dF9Skyn8JsF2Vu9Q=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-2FTu44EXbJPmzBGVB9DNDkvoQdcf0nyE3+wz+Pn2Z0s=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    cmake
    pkg-config
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libxml2
    gdk-pixbuf
    libadwaita
  ];

  meta = with lib; {
    description = "Tool for designing applications icons";
    homepage = "https://gitlab.gnome.org/World/design/app-icon-preview";
    license = licenses.gpl3;
    maintainers = with maintainers; [ zendo ];
  };
}
