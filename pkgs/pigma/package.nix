{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigma";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akirco";
    repo = "pigma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uR6U85S11XnTojy1ZEdqc7bhmFNp6ac3028o0JuX5uU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-hwESsiv+qdpAbyvMsW1cZ3XeYJPj7CF86Tb9z2q8ng4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
  ];

  # fatal error: cannot find 'ld' compilation terminated.
  postPatch = ''
    rm .cargo/config.toml

    # The binary target only calls `pigma::run()`, so from its point of view
    # every dependency is unused and the workspace-wide
    # `unused_crate_dependencies = "deny"` fails the whole build.
    substituteInPlace Cargo.toml \
      --replace-fail 'unused_crate_dependencies = "deny"' 'unused_crate_dependencies = "allow"'
  '';

  doCheck = false;

  meta = {
    description = "NetEase Cloud Music or local audio playback TUI client built with Ratatui";
    homepage = "https://github.com/akirco/pigma";
    changelog = "https://github.com/akirco/pigma/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pigma";
  };
})
