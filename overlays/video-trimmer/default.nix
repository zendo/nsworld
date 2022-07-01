{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  glib,
  gtk4,
  libadwaita,
  blueprint-compiler,
  gst_all_1,
  ffmpeg-full,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "video-trimmer";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "video-trimmer";
    rev = "v${version}";
    sha256 = "sha256-D7wjJkdqqjjwwYEUZnNr7hFQK59wfTnaCLXCy+SK8Jo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-cB5dVrEbISvHrOb87uVZSkT694VKtPtyk+c1tYNCTp0=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      blueprint-compiler
      wrapGAppsHook4
      appstream-glib
      desktop-file-utils
    ]
    ++ (with rustPlatform; [
      rust.cargo
      rust.rustc
      cargoSetupHook
    ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
    ffmpeg-full
  ]++ (with gst_all_1; [
    gstreamer
    gst-editing-services
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ]);

  # delete unused postinstall.py line
  patchPhase = ''
    sed -i '/postinstall.py/d' meson.build
  '';

  meta = with lib; {
    description = "Trim videos quickly";
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    license = licenses.gpl3;
    maintainers = with maintainers; [zendo];
  };
}
