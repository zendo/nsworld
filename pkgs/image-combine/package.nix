{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "image-combine";
  version = "1.0.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DestinEcarma";
    repo = "image-combine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ma6NXirkUpdeVBHNqKPEr74Mzq2bJAXmupV7C9HNASU=";
  };

  cargoHash = "sha256-O2iJXYg2XmbrEffsly+luKQsMjvh8GDJ8v47z7CncVE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Combining multiple images into one output image";
    homepage = "https://github.com/DestinEcarma/image-combine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "image-combine";
  };
})
