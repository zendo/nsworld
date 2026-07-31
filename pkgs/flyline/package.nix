{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o8ncjjnnyZIEb7qfnD6yY6YFq6JdppT+lKkVWZfdVdo=";
  };

  cargoHash = "sha256-Nc1v70Z/jgnvCDVEE4gK9lakZ/YEnkEtYc+EfwwLa9E=";

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
