{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  udev,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tuiba";
  version = "0.15.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Huseynteymurzade28";
    repo = "tuiba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/iSx+xofIhnJk+PP9T9miHUTIuWFXYIV0Iyeg2otcjo=";
  };

  cargoHash = "sha256-h6DBxkOKMqiFKS73a1oP9AdejoGyhEgmBDUYG3N9NFU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game Boy Advance emulator in your terminal";
    homepage = "https://github.com/Huseynteymurzade28/tuiba";
    changelog = "https://github.com/Huseynteymurzade28/tuiba/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "tuiba";
  };
})
