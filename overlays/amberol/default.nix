# WIP
{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  rustPlatform,
  gtk4,
  libadwaita,
  gst_all_1,
  appstream-glib,
  wrapGAppsHook4,
}:
stdenv.mkDerivation rec {
  pname = "amberol";
  version = "0.2.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "ebassi";
    repo = "amberol";
    rev = "${version}";
    sha256 = "3a8cbaeef17498796a6eab0b3f13175ed51106ed4c11e76a0686baaf2f5e447c";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "0qqp30s81jv3l479m3gsnb35200521pbah7mx1y6vzr9s8qdzcld";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    appstream-glib
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs =
    [
      gtk4
    ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-bad
    ]);

  meta = with lib; {
    description = "A small and simple sound and music player that is well integrated with GNOME";
    homepage = "https://gitlab.gnome.org/ebassi/amberol";
    license = licenses.gpl3;
    maintainers = with maintainers; [ zendo ];
    platforms = [ "x86_64-linux" ];
  };
}
