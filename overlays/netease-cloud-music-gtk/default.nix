{ lib
, stdenv
, fetchFromGitHub
, glib
, gtk4
, libadwaita
, gdk-pixbuf
, curl
, dbus
, openssl
, gst_all_1
, pkg-config
, rustPlatform
, meson
, ninja
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:
stdenv.mkDerivation rec {
  pname = "netease-cloud-music-gtk";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "gmg137";
    repo = "netease-cloud-music-gtk";
    rev = version;
    sha256 = "sha256-dlJZvmfw9+cavAysxVzCekgPdygg5zbU3ZR5BOjPk08=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-XpqXEBnrQmKssCEpmpVQWUrttSRSOLJiDCRJgMrPX0M=";
  };

  patches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
    gdk-pixbuf
    curl
    dbus
    openssl
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  meta = with lib; {
    description = "Unofficial netease cloud music player based on Rust + GTK";
    homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ diffumist zendo ];
  };
}
