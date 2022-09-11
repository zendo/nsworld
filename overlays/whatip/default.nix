{ lib
, fetchFromGitLab
, python3
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, blueprint-compiler
, gobject-introspection
, librsvg
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "whatip";
  version = "1.1";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GabMus";
    repo = pname;
    rev = version;
    hash = "sha256-ltimqdFTvvjXtvLC5jAdRaNX15i2Ww5mB3DIr4r9Yzg=";
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
    librsvg
    libadwaita
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    netaddr
    requests
    pygobject3
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  # dontWrapGApps = true;

  # preFixup = ''
  #   makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  # '';

  meta = with lib; {
    description = "Info on your IP";
    homepage = "https://gitlab.gnome.org/GabMus/whatip";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
