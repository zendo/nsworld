{ lib
, stdenv
, fetchFromGitHub
, python3
, meson
, ninja
, pkg-config
, gtk4
, glib
, libadwaita
, librsvg
, blueprint-compiler
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dynamic-wallpaper";
  version = "0.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "dusansimic";
    repo = pname;
    rev = version;
    hash = "sha256-DAdx34EYO8ysQzbWrAIPoghhibwFtoqCi8oyDVyO5lk=";
  };

  nativeBuildInputs = [
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
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  meta = with lib; {
    description = "Dynamic wallpaper maker for Gnome";
    homepage = "https://github.com/dusansimic/dynamic-wallpaper";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "me.dusansimic.DynamicWallpaper";
    maintainers = with maintainers; [ zendo ];
  };
}
