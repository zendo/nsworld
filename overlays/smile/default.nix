{ lib
, fetchFromGitHub
, python3
, meson
, ninja
, librsvg
, libwnck
, gobject-introspection
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smile";
  version = "1.7.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = pname;
    rev = version;
    hash = "sha256-4nqMKm3hILX9t3gbti2XSXjBeo2rvBa+O6nrTqRCntA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gobject-introspection
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    libwnck
    librsvg
  ];

  # propagatedNativeBuildInputs = [
  #   gobject-introspection
  # ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    manimpango
  ];

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  # prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "An emoji picker with custom tags support and localization for linux";
    homepage = "https://github.com/mijorus/smile";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
