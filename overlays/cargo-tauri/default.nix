{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  glibc,
  libsoup,
  cairo,
  gtk3,
  webkitgtk_4_1,
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    hash = "sha256-PDckSmq2KyWCwonSCpdriPhtZr5ppMi/8/4CJ54RcgQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "schemars_derive-0.8.21" = "sha256-AmxBKZXm2Eb+w8/hLQWTol5f22uP8UqaIh+LVLbS20g=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glibc
      libsoup
      cairo
      gtk3
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreServices
      Security
      SystemConfiguration
    ];

  doCheck = false;

  meta = with lib; {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    mainProgram = "cargo-tauri";
    homepage = "https://tauri.app/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      dit7ya
      happysalada
    ];
  };
}
