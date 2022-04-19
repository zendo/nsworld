/*
 WIP
 
 Traceback (most recent call last):
   File "/nix/store/lmw7jdgr5nja6qni2jsv7kyqm5xzcsg2-dialect-1.4.1/bin/.dialect-wrapped", line 33, in <module>
     from gi.repository import Gio
 ModuleNotFoundError: No module named 'gi'
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
  pkg-config,
  # , reuse
  wrapGAppsHook,
  makeWrapper,
  glib,
  gtk3,
  gtk4,
  libadwaita,
  gst_all_1,
  gobject-introspection,
  glib-networking,
  # , dbus
}:
stdenv.mkDerivation rec {
  pname = "dialect";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dialect-app";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-EPp6hKm+fTAUgo/SdaIeTa9WxZZkIhhr96ku1/NNo1o=";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
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
      gst_all_1.gstreamer
    ]
    ++ (with python3.pkgs; [
      dbus-python
      pygobject3
      gtts
      googletrans
      glib-networking
    ]);

  # makeWrapperArgs = with passthru.libraries; [
  #   "--prefix GIO_EXTRA_MODULES : ${dconf}/lib/gio/modules"
  # ];

  preAutoreconf = ''
    # The check runs before glib-networking is registered
    export GIO_EXTRA_MODULES="${glib-networking}/lib/gio/modules:$GIO_EXTRA_MODULES"
  '';

  meta = with lib; {
    homepage = "https://github.com/dialect-app/dialect";
    description = "A translation app for GNOME";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
