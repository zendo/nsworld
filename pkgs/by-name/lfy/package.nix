{ lib
, python3Packages
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
, shared-mime-info
, libadwaita
, libnotify
}:

python3Packages.buildPythonApplication rec {
  pname = "lfy";
  version = "0.0.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ldrfy";
    repo = "lfy";
    rev = "v${version}";
    hash = "sha256-1OuqlVqIaUaH59iw+N6gr9MiCVTrWVpr+5JnlUf2aVs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    shared-mime-info
  ];

  buildInputs = [
    libnotify
    libadwaita
    gobject-introspection
  ];

  dependencies = with python3Packages; [
    pygobject3
    requests
  ];

  strictDeps = false;

  # dontWrapGApps = true;

  # preFixup = ''
  #   makeWrapperArgs+=(
  #     "''${gappsWrapperArgs[@]}"
  #     --prefix LD_LIBRARY_PATH : $out/lib
  #   )
  # '';

  meta = {
    description = "Simple translate app for linux, support baidu tencent google";
    homepage = "https://github.com/ldrfy/lfy";
    mainProgram = "lfy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
