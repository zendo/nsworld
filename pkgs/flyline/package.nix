{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KciBcUsoMCGuw8bHlVBDHAB55lDfyeGoJxBldmj0MVs=";
  };

  cargoHash = "sha256-zTL33etJpEHGPOrw+mUR6JUP1jzPdHBrGYJZjea13WU=";

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
