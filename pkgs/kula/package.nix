{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGo127Module (finalAttrs: {
  pname = "kula";
  version = "0.20.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-LdIMYk1HYjZsKEQaFOh6LGTbMZB27FmIg2Y9uJQ7i5I=";
  };

  vendorHash = "sha256-U7cOShly1jLvmHqJ9UBMXsX2+7b/ehaoF9R2XsBIb3I=";

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
