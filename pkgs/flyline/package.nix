{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flyline";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gmkp9gxI5xcU0n2rCc1TBh7C+cWi0GwIUyP7C+xKuA4=";
  };

  cargoHash = "sha256-pf8JMBQxUoLjo7mpqFYa/yJpZc2ZJOZqMx0oMEKB7wA=";

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
