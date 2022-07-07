/*
Traceback (most recent call last):
  File "/nix/store/x9h0v5cq2yp5m0kgkij6vbgnzpcqmccr-gpu-viewer-1.42/share/gpu-viewer/Files/GPUViewer.py", line 6, in <module>
    from Common import MyGtk, setScreenSize
  File "/nix/store/x9h0v5cq2yp5m0kgkij6vbgnzpcqmccr-gpu-viewer-1.42/share/gpu-viewer/Files/Common.py", line 1, in <module>
    import gi
ModuleNotFoundError: No module named 'gi'
*/

{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  python3Packages,
  meson,
  ninja,
  pkg-config,
  gtk3,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  libadwaita,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "gpu-viewer";
  version = "1.42";

  src = fetchFromGitHub {
    owner = "arunsivaramanneo";
    repo = "GPU-Viewer";
    rev = "v${version}";
    sha256 = "sha256-RKJAh7ON2rIJNH8HFYIOeStiMv7yhuQsVJHZntWd488=";
  };

  # setup.py and pyproject.toml not found
  format = "other";

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
    # gdk-pixbuf
    # libadwaita
  ];

  # pythonPath = with python3.pkgs; requiredPythonModules [pygobject3];

  # doCheck = false;

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
  ];

  postPatch = ''
    patchShebangs Files/GPUViewer.py
  '';

  # preFixup = ''
  #   gappsWrapperArgs+=(
  #      --prefix PATH : "${lib.makeBinPath [python3]}"
  #   )
  # '';

  meta = with lib; {
    homepage = "https://github.com/arunsivaramanneo/GPU-Viewer";
    description = "A front-end to glxinfo, vulkaninfo, clinfo and es2_info";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
