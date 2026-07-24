{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-acp";
  version = "0.0.32";

  src = fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NksKacRpopm8lAaOG9tbHxJAcr4rlU0uL3dl/VkFbAA=";
  };

  npmDepsHash = "sha256-sRBrTwBwo8pcOy5WGDxHE86fvldgOtlppuvcbiB+7uc=";

  # npmFlags = [
  #   "--ignore-scripts"
  # ];
  #
  # makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ nodejs ]}" ];
  #
  # doInstallCheck = false;

  meta = {
    description = "ACP adapter for the Pi coding agent";
    homepage = "https://github.com/svkozak/pi-acp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pi-acp";
  };
})
