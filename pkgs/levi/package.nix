{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "levi";
  version = "0.18.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rsdlt";
    repo = "levi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZaDiV3/NIdEBew6XD8eBMdcYInsxtGGPyqPtsi2uXYk=";
  };

  cargoHash = "sha256-oG8jkJWjOnrbptBQOX00y9adaNGHtaPk3slwlv4tVy4=";

  nativeCheckInputs = [ gitMinimal ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fastest blade for your git history";
    homepage = "https://github.com/rsdlt/levi";
    changelog = "https://github.com/rsdlt/levi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "levi";
  };
})
