{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vala
, glib
, gtk4
, libsoup_3
, libgee
, libcanberra
, gdk-pixbuf
, json-glib
, qrencode
, sqlite
, cairo
, curl
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
, python3
}:

stdenv.mkDerivation rec {
  pname = "gabutdm";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "gabutakut";
    repo = pname;
    rev = version;
    hash = "sha256-0K1TugPMQjFIJKMFoOCjAp8NJR+uckLafeUnu7DTkA0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    libsoup_3
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    python3 # for post_install.py
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libcanberra
    gdk-pixbuf
    json-glib
    qrencode
    sqlite
    cairo
    curl
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Simple and Faster Download Manager";
    homepage = "https://github.com/gabutakut/gabutdm";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "com.github.gabutakut.gabutdm";
    maintainers = with maintainers; [ zendo ];
  };
}
