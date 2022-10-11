{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, appstream-glib
, desktop-file-utils
, gettext
, glib
, gst_all_1
, gtk4
, libadwaita
, librsvg
, libsoup_3
, dbus
, meson
, ninja
, pkg-config
, pulseaudio
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "mousai";
  version = "unstable-2022-09-30";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Mousai";
    # rev = "v${version}";
    rev = "4f8e0f819e79160e6b729f9f89fef6b1819d2cf6";
    hash = "sha256-VPkEBrJZJm3MmEmDNJTq2WVNykzY3ShhUXhvXmbVBxc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/YEToPHuLv2DWmDutc6/QlOREa0rZaoNiyTe7Vstabs=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gtk4
    libadwaita
    librsvg
    libsoup_3
    dbus
    pulseaudio
  ];

  meta = with lib; {
    description = "Identify any songs in seconds";
    homepage = "https://github.com/SeaDve/Mousai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
