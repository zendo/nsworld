{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "netease-ratui";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "xlfish233";
    repo = "netease-ratui";
    rev = "v${version}";
    hash = "sha256-GSbprJLPjlAW1kpgDntDIC/0NJY1EkLOcO3TGNsYry4=";
  };

  cargoHash = "sha256-g9IuQzmbsSiyODJzfJSz4PiwPOenAtTrg93j39LiD0o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  meta = {
    description = "Another netease tui player";
    homepage = "https://github.com/xlfish233/netease-ratui";
    changelog = "https://github.com/xlfish233/netease-ratui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit; # fake
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "netease-ratui";
  };
}
