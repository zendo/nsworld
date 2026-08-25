{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

buildGo126Module (finalAttrs: {
  pname = "kula";
  version = "0.18.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-K3bHs0FIVyWIUjDrmxcUsrISagcXlBVWkcea+tTcuVM=";
  };

  vendorHash = "sha256-hhpEQNVfRYLQXiUjn9dicfshzXt3wRnXeqtOo5/ptxs=";

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
