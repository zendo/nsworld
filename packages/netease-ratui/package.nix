{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "netease-ratui";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "xlfish233";
    repo = "netease-ratui";
    rev = "v${version}";
    hash = "sha256-5+lJAGilBBuuTTgmMggT/rhLx90uYBGfDnI9h+wz91s=";
  };

  cargoHash = "sha256-nZKc9PXVZ5rPknviD/GCTMj3CPoy+tbJJnz7zWMepfE=";

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
