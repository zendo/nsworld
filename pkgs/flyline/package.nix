{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2apK1e/Hqb8bUj9Ng7cB+pz27Hv14MXMy2JYYI7nxKE=";
  };

  cargoHash = "sha256-Ci1PVqGZ4ttrkUAtePHKKsqI/SVoedlH4Mua7MzFDvo=";

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
