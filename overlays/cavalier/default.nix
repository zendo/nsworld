{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, glib
, gtk4
, librsvg
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cavalier";
  version = "0.1.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "fsobolev";
    repo = pname;
    rev = "0d940af86dae0925209f2b488416f0446a97de21";
    hash = "sha256-pNVt6rPJd/IG2fNcFJEZav0Ohkm+WDzuj6DSiZacxlY=";
  };

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
    # librsvg
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  # prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Audio visualizer based on CAVA with customizable LibAdwaita interface";
    homepage = "https://github.com/fsobolev/cavalier";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
