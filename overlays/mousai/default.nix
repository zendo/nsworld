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
    rev = "1fe05c12cb73bea7c793a06bf84d3747491ea9b7";
    hash = "sha256-eftIMdCePBYPS1uS9J9rDYsIQotZ5h8KWoScYAcCpd0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-Dz/IJ8Gnd6lj2b5EnDm9xHZRCSBNvSRdXmyu2gWVUuM=";
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
