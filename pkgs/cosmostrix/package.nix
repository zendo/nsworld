{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmostrix";
  version = "2.0.0-stable.1";

  src = fetchFromGitHub {
    owner = "oxyzenQ";
    repo = "cosmostrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZYSBRTt1QDAMpnmgfshDznzaJ0vmnZGXxnOwCSlUPU0=";
  };

  cargoHash = "sha256-mGm5dpfcX/FcfPFYpEuvSuGxmlyF1JFwzgF33Ynog0E=";

  __structuredAttrs = true;

  meta = {
    description = "High-performance cinematic terminal renderer";
    homepage = "https://github.com/oxyzenQ/cosmostrix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "cosmostrix";
  };
})
