{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "linux-boot-analyzer";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "06ergin06";
    repo = "linux_boot_analyzer_tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQm9WRE2XiDa/04k+4ey7tPx1sSybrRGNuyIfxCI4CI=";
  };

  cargoHash = "sha256-rrxrG6AGl4z0Ylcx9vWonWmGUoLoSkSkX6E7HXbH81Q=";

  # Nothing is read from the machine at build time; the tests are the crate's
  # own and pass without systemd.
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI that analyses Linux boot time and manages systemd services";
    homepage = "https://github.com/06ergin06/linux_boot_analyzer_tui";
    changelog = "https://github.com/06ergin06/linux_boot_analyzer_tui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    mainProgram = "linux-boot-analyzer";
    platforms = lib.platforms.linux;
  };
})
