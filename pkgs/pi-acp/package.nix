{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:

buildNpmPackage (finalAttrs: {
  pname = "pi-acp";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "svkozak";
    repo = "pi-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bM3V/3fxkY2Ib+OyfT82StIIRSLXGDuYUbt1CZKpTuo=";
  };

  npmDepsHash = "sha256-qN+b/tMbnJLkWjotl3XrA0nfZ3KT/mT6gM+n3Qiz8Wk=";

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
