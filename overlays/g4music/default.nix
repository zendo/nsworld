# wip
{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  cmake,
  gtk4,
  glib,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  gst_all_1,
  dbus,
  m4,
  reuse,
}:
stdenv.mkDerivation rec {
  pname = "g4music";
  version = "1.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "neithern";
    repo = pname;
    rev = "ef13f16b75e001721262324d355b7b7d3f5e2b77";
    hash = "sha256-Uuq3zzCPbxeG+1hORbRFBCSaGFlItohHYW4W+3yRxMQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    cmake
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
    ]
    ++ (with gst_all_1; [
      gstreamer
      # gst-editing-services
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      # gst-libav
    ]);

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "A small and simple sound and music player";
    maintainers = with maintainers; [linsui];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
