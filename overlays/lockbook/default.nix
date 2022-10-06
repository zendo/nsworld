{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, openssl
, fontconfig
, glib
, gtk4
, pango
, gdk-pixbuf
, gtksourceview5
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

rustPlatform.buildRustPackage rec {
  pname = "lockbook";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-yAZBqOHjoiaLenRVBH+EXr9/5ni3wRffnN15oJ/SgqM=";
  };

  cargoHash = "sha256-ibfmwHPP3TUZRpSIXWMBWomLhFNOxd3L59pmVGHxJNE=";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    openssl
    fontconfig
    glib
    gtk4
    gdk-pixbuf
    pango
    gtksourceview5
  ];

  doCheck = false;

  meta = with lib; {
    description = "The private, polished note-taking platform";
    homepage = "https://github.com/lockbook/lockbook";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
