{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3
, gobject-introspection
, gtksourceview5
, webkitgtk_5_0
, glib
, gtk4
, librsvg
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "iotas";
  version = "0.1.5";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "cheywood";
    repo = pname;
    rev = version;
    hash = "sha256-wGqpjPx9nuAPmdJuiIC6aXfEvDbiT1CTcYbeEOa0OTk=";
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
    gobject-introspection
    gtksourceview5
    webkitgtk_5_0
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pygtkspellcheck
    requests
    markdown-it-py
    mdit-py-plugins
  ];

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Simple note taking with mobile-first design and Nextcloud sync";
    homepage = "https://gitlab.gnome.org/cheywood/iotas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
