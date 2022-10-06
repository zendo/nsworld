{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libxml2
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "game-of-life";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "sixpounder";
    repo = pname;
    # rev = "v${version}";
    rev = "42f6f661bafcc4f7f353f3b8a6e1eb4779c9ebc6";
    hash = "sha256-u7vYTlFZaxyGnVt3xf7rDdGGq75BreuKVc9EqbYxVaY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-LeqRSMN9mJAIyQAeP5wg+kVatw6+MjHWt0LiyplUeYI=";
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
    libxml2
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "A simple Conway's game of life simulator for the Gnome desktop";
    homepage = "https://github.com/sixpounder/game-of-life";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
