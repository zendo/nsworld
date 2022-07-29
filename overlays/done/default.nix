{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, meson
, ninja
, pkg-config
, sqlite
, libxml2
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "done";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6hXBgH9eTcanW+AnuOdLqSQBS/0m0T06dU4rzaVUx7M=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-rs7RUKQ+JF5i338bTQERhSMsPntMb7M7jWf+hu+KsYc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxml2 # for xmllint
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
    sqlite
  ];

  meta = with lib; {
    description = "A simple todo app written in GTK and Rust";
    homepage = "https://github.com/edfloreshz/done";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
