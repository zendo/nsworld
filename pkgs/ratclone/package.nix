{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ratclone";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "SyscallBrain";
    repo = "ratclone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fMBic9CbmxKKEDqLATNcFALcrQMpCIR8zki1+Oh6U8M=";
  };

  cargoHash = "sha256-9O+lje6BSbakFCzheQDz73euMG0E0WkARlyBmR6Q49k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Keyboard-driven terminal UI for rclone, with Vim keys";
    homepage = "https://github.com/SyscallBrain/ratclone";
    changelog = "https://github.com/SyscallBrain/ratclone/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ratclone";
  };
})
