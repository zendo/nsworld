{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  poetry,
  leptonica,
  tesseract,
  pyside2,
  # meson,
  # ninja,
  # pkg-config,
  # gtk3,
  # glib,
  # libportal-gtk3,
  # libnotify,
  # gobject-introspection,
  # wrapGAppsHook,
  # appstream-glib,
  # desktop-file-utils,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "normcap";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dynobo";
    repo = "normcap";
    rev = "v${version}";
    sha256 = "sha256-yOjfiGJUU25zb/4WprPss9yDAMpttS3jREp1kB5mXUE=";
  };

  # setup.py and pyproject.toml not found
  format = "pyproject";

  nativeBuildInputs = [
    poetry
    # meson
    # ninja
    # pkg-config
    # gobject-introspection
    # wrapGAppsHook
    # appstream-glib
    # desktop-file-utils
  ];

  buildInputs = [
    leptonica tesseract
    # glib
    # gtk3
    # leptonica
    # libportal-gtk3
    # libnotify
  ];

  propagatedBuildInputs = [ pyside2 ];

  # propagatedBuildInputs = [
  #   libnotify
  #   python3.pkgs.pydbus
  #   python3.pkgs.dbus-python
  #   python3.pkgs.pillow
  #   python3.pkgs.notify-py
  #   python3.pkgs.pyxdg
  #   python3.pkgs.xlib
  #   python3.pkgs.pygobject3
  #   python3.pkgs.pyzbar
  # ];

  # pythonPath = with python3.pkgs; requiredPythonModules [ pygobject3 ];

  # postUnpack = ''
  # (
  # cd "$sourceRoot"
  # rm build-aux/meson/postinstall.py
  # )
  # '';

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  # delete finnal line to stop exec postinstall.py
  # patchPhase = ''
  #   sed -i '$ d' meson.build
  # '';

  meta = with lib; {
    homepage = "https://github.com/TenderOwl/Frog";
    description = "Intuitive text extraction tool (OCR) for GNOME";
    maintainers = with maintainers; [zendo];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
