{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  # openssl,
  wrapGAppsHook,
  appstream-glib,
  desktop-file-utils,
}:

rustPlatform.buildRustPackage rec {
  pname = "hotwire";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "emmanueltouzery";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1fk8h9g2OwalaxA09hh0u1jKFGGhxVrbWz8SIgdicxo=";
  };

  cargoSha256 = "sha256-FjERYQUJ2cZe7DbxkgHwlbUU/9BvdG7B9KSRLCqq290=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
  ];

  # buildInputs = [
  #   openssl
  # ];

  meta = with lib; {
    description = "Modern editor for the terminal";
    homepage = "https://github.com/mcobzarenco/zee";
    license = [licenses.mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
