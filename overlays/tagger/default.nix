{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, jsoncpp
, taglib
, curl
, curlpp
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "tagger";
  version = "2022.10.1-next1";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTagger";
    # rev = version;
    rev = "7b9ebea010134fca81c645c26f5cff4a90cb6c5f";
    hash = "sha256-78WN4sUsmvekHTuTChdoXSaaj07PrkrJZhxEsvmEcLs=";
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
    taglib
    curl
    curlpp
  ];

  # postPatch = ''
  #   substituteInPlace src/ui/application.hpp \
  #   --replace "G_APPLICATION_DEFAULT_FLAGS" "G_APPLICATION_GET_CLASS"
  # '';

  meta = with lib; {
    description = "A simple todo app written in GTK and Rust";
    homepage = "https://github.com/nlogozzo/NickvisionTagger";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
