/*
 WIP
 httpx
 */
{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  desktop-file-utils,
  appstream-glib,
  meson,
  ninja,
  cmake,
  pkg-config,
  # , reuse
  wrapGAppsHook,
  makeWrapper,
  glib,
  gtk3,
  gtk4,
  httpx,
  libadwaita,
  libhandy,
  gst_all_1,
  gobject-introspection,
  glib-networking,
  # , dbus
}:
python3.pkgs.buildPythonApplication rec {
  pname = "dialect";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dialect-app";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-EPp6hKm+fTAUgo/SdaIeTa9WxZZkIhhr96ku1/NNo1o=";
  };

  # setup.py and pyproject.toml not found
  format = "other";

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    cmake
    pkg-config
    # reuse
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs =
    [
      glib
      gtk3
      gtk4
      libadwaita
      libhandy
      gobject-introspection
      gst_all_1.gstreamer
    ]
    ++ (with python3.pkgs; [
      dbus-python
      pygobject3
      gtts
      googletrans
      glib-networking
    ]);

  propagatedBuildInputs = [
    httpx
  ];

  pythonPath = with python3.pkgs; requiredPythonModules [
    pygobject3
    googletrans
  ];


  # makeWrapperArgs = with passthru.libraries; [
  #   "--prefix GIO_EXTRA_MODULES : ${dconf}/lib/gio/modules"
  # ];

  # preAutoreconf = ''
  #   # The check runs before glib-networking is registered
  #   export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  # '';

  meta = with lib; {
    homepage = "https://github.com/dialect-app/dialect";
    description = "A translation app for GNOME";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
