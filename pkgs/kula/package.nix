{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGo126Module (finalAttrs: {
  pname = "kula";
  version = "0.18.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-2oIVAEM5xwC7WeACIj7ZLRPiQQtVZ7HYPWCHNdAvML0=";
  };

  vendorHash = "sha256-ZtRECNlt64BnO5Ixvu4S9kEvrrvEo0eiC71CnS3eIxg=";

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
