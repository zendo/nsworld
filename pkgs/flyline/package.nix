{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bKFTAAN+A3Po0PnVv1XYQyLWqBQT3btYUUuFu7jcCXA=";
  };

  cargoHash = "sha256-6nEcshn1IuF1QHcsqoFbw/q7Px5CAYxqhOvU/twfyAs=";

  doCheck = false;

  meta = {
    description = "Bash plugin for modern command line editing";
    longDescription = ''
      Flyline: a Bash plugin to replace readline for a modern line editing experience:
      syntax highlighting, agent integration, rich prompts, tooltips, fuzzy history search, and more.
    '';
    homepage = "https://github.com/HalFrgrd/flyline";
    changelog = "https://github.com/HalFrgrd/flyline/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})
