{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtop";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "swedishembedded";
    repo = "rtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hi7T5HhmTjpAQC9lsiAV/z2CKbwwiSHp/2kyoXDoJYo=";
  };

  cargoHash = "sha256-cF6t0+2pM0gRLwd8TX4IliAg2pgno/+jlrH+wG+uLQU=";

  nativeBuildInputs = [ installShellFiles ];

  # The workspace only ships one user facing binary; the other crates are libraries.
  cargoBuildFlags = [
    "--package"
    "rtop"
  ];
  # crates/rtop has integration tests that drive the TUI through a vt100 screen.
  doCheck = false;

  postInstall = ''
    installManPage docs/rtop.1
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time Linux telemetry graph and process manager with a Vim- and mouse-native terminal UI";
    homepage = "https://github.com/swedishembedded/rtop";
    changelog = "https://github.com/swedishembedded/rtop/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
    mainProgram = "rtop";
  };
})
