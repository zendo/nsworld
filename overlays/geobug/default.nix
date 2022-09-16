{ lib
, fetchFromGitea
, python3
, glib
, gtk3
, libadwaita
, gobject-introspection
, libhandy
, geoclue2
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "geobug";
  version = "0.1.2";

  format = "setuptools";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tpikonen";
    repo = pname;
    rev = version;
    hash = "sha256-X2WqBN+jw8GUOkqf9pjCr2clj81S0FJs1be9z2qDiiI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    geoclue2
    libhandy
    # libadwaita
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    gpxpy
    pygobject3
  ];

  # doCheck = false;

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  # dontWrapGApps = true;

  # preFixup = ''
  #   makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  # '';

  meta = with lib; {
    description = "An adaptive client for GeoClue";
    homepage = "https://codeberg.org/tpikonen/geobug";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
