{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, libxml2
, gst_all_1
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gnome-metronome";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "metronome";
    # rev = version;
    rev = "4f496602188a9f77771a9e671d69ea878bcfca3c";
    hash = "sha256-szqxY0fX9S3qfTXz+on/3cG+VkXCtE4sGkGjQCl2Tbw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-QFzxsuYA9dRrbjl5v+HIQAbNxDbr//+kn3uWHEtPKqc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    libxml2
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    # gst-plugins-ugly
  ]);

  mesonFlags = [ "-Dprofile=default" ];

  postPatch = ''
    patchShebangs build-aux/dist-vendor.sh
    chmod +x build-aux/dist-vendor.sh
  '';

  meta = with lib; {
    description = "Keep the tempo";
    homepage = "https://gitlab.gnome.org/World/metronome";
    mainProgram = "metronome";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
