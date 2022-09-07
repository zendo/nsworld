{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  gtk4,
  glib,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "dynamic-wallpaper";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "dusansimic";
    repo = "dynamic-wallpaper";
    rev = "${version}";
    hash = "sha256-y6BgOK4Evz/SZeLKwNZuv9+uG/FHxK4Wd+RrMlGYQb8=";
  };

  # setup.py and pyproject.toml not found
  format = "other";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  pythonPath = with python3.pkgs; requiredPythonModules [pygobject3];

  meta = with lib; {
    homepage = "https://github.com/dusansimic/dynamic-wallpaper";
    description = "Dynamic wallpaper maker for Gnome";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
