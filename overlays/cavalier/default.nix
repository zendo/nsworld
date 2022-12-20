{ lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, cava
, gobject-introspection
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
  version = "2022.12.18";
  format = "other";

  src = fetchFromGitHub {
    owner = "fsobolev";
    repo = pname;
    rev = version;
    hash = "sha256-yf3n9RYLaGuiKnvjX+4uSp9yaioCMch2Hn1JQ2tofBg=";
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
  ];

  # Prevent double wrapping
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH ":" "${lib.makeBinPath [ cava ]}"
    )
  '';

  meta = with lib; {
    description = "Audio visualizer based on CAVA with customizable LibAdwaita interface";
    homepage = "https://github.com/fsobolev/cavalier";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
