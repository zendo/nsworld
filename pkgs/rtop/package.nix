{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "swedishembedded";
    repo = "rtop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h+d9g0zaZrENOhV3ynbYF3WZxI1h+S5eDOfSG5WieQI=";
  };

  cargoHash = "sha256-KYJcy46TLSG943qwaVDLAyfkKQDYdr4LOEDyL4BDzmo=";

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
