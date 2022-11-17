{ lib
, fetchFromGitLab
, python3
, meson
, ninja
, pkg-config
, glib
, gtk3
, gettext
, xdotool
  , libinput-gestures
, gobject-introspection
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
}:
       # > Executing pipInstallPhase
       # > /nix/store/vpxfszmnknllapd7c3vfb637r8z5yhpl-pip-install-hook/nix-support/setup-hook: line 13: pushd: dist: No such file or directory

python3.pkgs.buildPythonApplication rec {
  pname = "gestures-gtk";
  version = "0.3.1";
  format = "others";

  src = fetchFromGitLab {
    owner = "cunidev";
    repo = "gestures";
    rev = version;
    hash = "sha256-Vzt3HOXE3plFkXBqNZbLFoZSe3tycdYwNRwqfgHUYuA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk3
    gettext
    xdotool
    libinput-gestures
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  # postPatch = ''
  #   chmod +x build-aux/meson/postinstall.py
  #   patchShebangs build-aux/meson/postinstall.py
  # '';

  # prevent double wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Editor for Markdown and reStructuredText";
    homepage = "https://gitlab.com/cunidev/gestures";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
