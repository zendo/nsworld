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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zja1a2tQFRuaVwNilgRsnNxbHOzhkX7FnUXg5HGjEPo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-KBjM7JOt4ZKbwnfITXdXVSKhVZ+wJIeTyuEB6z+HILM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxml2
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
    sqlite
    libadwaita
  ];

  meta = with lib; {
    description = "A simple todo app written in GTK and Rust";
    homepage = "https://github.com/edfloreshz/done";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
