# WIP
{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  glib,
  atk,
  gtk3,
  libappindicator-gtk3,
  libsoup,
  webkitgtk,
  # electron,
  makeWrapper,
}:
# let
mkYarnPackage rec {
  pname = "clash-verge";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = "clash-verge";
    rev = "v${version}";
    sha256 = "sha256-TVXWPUbSYPN34y7WYK9Viy6Kkb5dK4x/jVuZpKuzYeg=";
  };
  gui = rustPlatform.buildRustPackage {
    inherit pname version;
    src = "${src}/src-tauri";

    cargoSha256 = "sha256-CJttSlCy38kyaUBq7NYuXVOGKQUvP/goEJ/g3Hst44E=";
    nativeBuildInputs = [pkg-config];
    buildInputs = [
      openssl
      glib
      atk
      gtk3
      libappindicator-gtk3
      libsoup
      webkitgtk
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/zzzgydi/clash-verge";
    description = "A Clash GUI based on tauri";
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
