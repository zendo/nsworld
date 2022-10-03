{
  lib,
  fetchFromGitHub,
  python3,
  meson,
  ninja,
  pkg-config,
  glib,
  gtk3,
  libadwaita,
  blueprint-compiler,
  gobject-introspection,
  librsvg,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "gpu-viewer";
  version = "1.42";

  format = "other";

  src = fetchFromGitHub {
    owner = "arunsivaramanneo";
    repo = "GPU-Viewer";
    rev = "v${version}";
    hash = "sha256-RKJAh7ON2rIJNH8HFYIOeStiMv7yhuQsVJHZntWd488=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    # librsvg
    # libadwaita
    gobject-introspection
  ];

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # netaddr
    # requests
    pygobject3
  ];

  postPatch = ''
    patchShebangs .
  '';

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
    maintainers = with maintainers; [zendo];
  };
}
