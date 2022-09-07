{ lib
, stdenv
, fetchFromGitHub
, python3
, meson
, ninja
, pkg-config
, glib
, gtk3
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "eartag";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "knuxify";
    repo = pname;
    rev = version;
    hash = "sha256-vNAKGwcvkZ3YdrA0uYTnlyta2az/bmjgCE/6e9NADT0=";
  };

  nativeBuildInputs = [
    python3
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    # For postinstall.py
    glib
    gtk3
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    eyeD3
    pillow
    mutagen
    pytaglib
    pygobject3
    python-magic
  ];

  format = "other";

  # handle setup hooks better
  strictDeps = false;

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Small and simple music tag editor";
    homepage = "https://github.com/knuxify/eartag";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
