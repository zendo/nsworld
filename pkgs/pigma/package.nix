{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigma";
  version = "0.2.16";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akirco";
    repo = "pigma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y543X/vChW+lBAEeSDtFFWOAKxaF2VEr9Z2dADeznBE=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-2xwwhmG2bVh7fmG6mfqPHgCtbUd+DGOn+8uNjcioBho=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
  ];

  # fatal error: cannot find 'ld' compilation terminated.
  postPatch = ''
    rm .cargo/config.toml
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
