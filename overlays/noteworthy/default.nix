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
, openssl
  , libpulseaudio
, gtksourceview5
, dbus
, meson
, ninja
, pkg-config
, pulseaudio
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "noteworthy";
  version = "unstable-2022-04-15";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Noteworthy";
    # rev = "v${version}";
    rev = "4b78260ee27a1869d01e4675935eacc0da0ac9e3";
    hash = "sha256-driLcwPq1PFkgooToLqWoBr4Cx6KhmRSNxZX915HSHY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-N9K9/n4vO9ydqME+1T0HDobGmMs48t5x4cdyQKZAFcA=";
  };

  nativeBuildInputs = [
    # gettext
    # glib
    # gtk4
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
    openssl
    gtk4
    libadwaita
    librsvg
    gtksourceview5
    libpulseaudio
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    # gst-plugins-ugly
  ]);

  meta = with lib; {
    description = "Modern, Fast, and Version-Controlled Markdown Notes";
    homepage = "https://github.com/SeaDve/Noteworthy";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
