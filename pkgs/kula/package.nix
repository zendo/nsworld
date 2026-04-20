{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGo126Module (finalAttrs: {
  pname = "kula";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-RSKPMtkoRC06g+doon7ARzsbsJz2fUBHNGl/uPA7l44=";
  };

  vendorHash = "sha256-Bx3CG0ZvMyEu4QJPM+f/AC5wDH2qqo3ByFUbQYB/MAo=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  meta = {
    description = "Lightweight, self-contained Linux® server monitoring tool";
    homepage = "https://kula.ovh";
    downloadPage = "https://github.com/c0m4r/kula";
    changelog = "https://github.com/c0m4r/kula/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "kula";
  };
})
