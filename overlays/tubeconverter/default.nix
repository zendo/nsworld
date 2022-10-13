{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, jsoncpp
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "tubeconverter";
  version = "2022.10.1";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTubeConverter";
    rev = version;
    # rev = "0ce7c8a94b9b44f5f17b9396eb573cbc3e066d8f";
    hash = "sha256-OnW14PuZfNUDtsykD02TuANrZqR4sleNP0UnxWe0IbU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    jsoncpp
  ];

  # postPatch = ''
  #   substituteInPlace meson.build \
  #     --replace fpcalc "${chromaprint}/bin/fpcalc"
  # '';

  meta = with lib; {
    description = "A simple todo app written in GTK and Rust";
    homepage = "https://github.com/nlogozzo/NickvisionTagger";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
