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
  version = "0.99";

  src = fetchFromGitHub {
    owner = "dusansimic";
    repo = "dynamic-wallpaper";
    rev = "f090a7219a929802a022a604390532781c19c548";
    sha256 = "sha256-6ce5aqipPS0W5Blc87Ca9aj4lMKef3+0sprpB1izl+Y=";
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

  pythonPath = with python3.pkgs; requiredPythonModules [  pygobject3 ];

  meta = with lib; {
    homepage = "https://github.com/dusansimic/dynamic-wallpaper";
    description = "Dynamic wallpaper maker for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
