{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  oniguruma,
  stdenv,
  darwin,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "television";
  version = "0.4.20";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    rev = "v${version}";
    hash = "sha256-o00Mk6s+mT0946gS5A5P9FHlZ60wg6AX63mWVkwoHsY=";
  };

  cargoHash = "sha256-dH+ZBXRvydDbSMk+v/ypz1k8t1DElz0j2OBuy+y23HQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  # buildInputs = [
  #   libxkbcommon
  #   oniguruma
  # ] ++ lib.optionals stdenv.isDarwin [
  #   darwin.apple_sdk.frameworks.AppKit
  # ] ++ lib.optionals stdenv.isLinux [
  #   wayland
  # ];

  meta = {
    description = "Blazingly fast general purpose fuzzy finder for your terminal written in Rust";
    homepage = "https://github.com/alexpasmantier/television";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "tv";
  };
}
