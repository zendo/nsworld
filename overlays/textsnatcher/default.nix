{ lib
, stdenv
, fetchFromGitHub
, vala
, meson
, ninja
, pkg-config
, pantheon
, python3
, glib
, gtk3
, gdk-pixbuf
, libhandy
, libportal
, scrot
, tesseract
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "textsnatcher";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "RajSolai";
    repo = "TextSnatcher";
    rev = "v${version}";
    hash = "sha256-phqtPjwKB5BoCpL+cMeHvRLL76ZxQ5T74cpAsgN+/JM=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    # python3
    # glib
    # gtk3
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    libhandy
    libportal
    pantheon.granite
  ];

  preFixup = ''
    gappsWrapperArgs+=(
    --prefix PATH : "${lib.makeBinPath [ tesseract scrot ]}"
    )
  '';

  # postPatch = ''
  #   chmod +x meson/post_install.py
  #   patchShebangs meson/post_install.py
  # '';

  meta = with lib; {
    description = "Copy Text from Images with ease, Perform OCR operations in seconds";
    homepage = "https://github.com/RajSolai/TextSnatcher";
    mainProgram = "com.github.rajsolai.textsnatcher";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
