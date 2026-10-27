{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGoLatestModule (finalAttrs: {
  pname = "kula";
  version = "0.21.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-AccxpBAeLfpWaruogkBDy7ioPwkdDuenfugk61tOiZ0=";
  };

  vendorHash = "sha256-4OQJP52S5o5ER/vvl2MA0ME9HdXMcSm55x7Xcu3ljrU=";

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
