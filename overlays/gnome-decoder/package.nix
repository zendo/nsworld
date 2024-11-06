{
  lib,
  clangStdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustc,
  glib,
  gtk4,
  libadwaita,
  zbar,
  sqlite,
  openssl,
  pipewire,
  gst_all_1,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:

clangStdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    hash = "sha256-qSPuEVW+FwC9OJa+dseIy4/2bhVdTryJSJNSpes9tpY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-MbfukvqlzZPnWNtWCwYn7lABqBxtZWvPDba9Deah+w8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    zbar
    sqlite
    openssl
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-rs
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; })
  ];

  meta = {
    description = "Scan and Generate QR Codes";
    homepage = "https://gitlab.gnome.org/World/decoder";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "decoder";
    maintainers = with lib.maintainers; [ zendo ];
  };
}
