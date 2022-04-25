{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  cmake,
  glib,
  gtk3,
  json-glib,
  libgee,
  libsoup,
  pantheon,
  geocode-glib,
  geoclue2,
  libadwaita,
  gst_all_1,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "tuner";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "louis77";
    repo = pname;
    rev = version;
    sha256 = "sha256-tG1AMEqHcp4jHNgWDy9fS2FtlxFTlpMD5MVbepIY+GY=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    cmake
    pkg-config
    appstream-glib
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libgee
    libsoup
    libadwaita
    json-glib
    geocode-glib
    geoclue2
    pantheon.granite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  meta = with lib; {
    homepage = "https://github.com/louis77/tuner";
    description = "Minimalist radio station player";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
