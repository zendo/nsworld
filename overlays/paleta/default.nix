{ lib
, python3
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, librsvg
, libadwaita
}:

python3.pkgs.buildPythonApplication rec {
  pname = "paleta";
  version = "unstable-2023-02-06";
  format = "other";

  src = fetchFromGitHub {
    owner = "nate-xyz";
    repo = pname;
    rev = "c68503b12d4a600137ba3c324502057d299d30c7";
    hash = "sha256-cCrgnfLSUkiDdZiGtgqwd2XeUmJafXVBNlwmIenBTIM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    colorthief
    pillow
    pyxdg
  ];

  meta = with lib; {
    description = "Find the dominant color palette from any image and manage palettes";
    homepage = "https://github.com/nate-xyz/paleta";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
