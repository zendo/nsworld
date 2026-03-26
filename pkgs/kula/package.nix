{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "kula";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "c0m4r";
    repo = "kula";
    tag = finalAttrs.version;
    hash = "sha256-KzJJYko4oaAQGmxwiFMth8scOuYe0bVB8abe8qal/jE=";
  };

  vendorHash = "sha256-ZBtlwH54irGAAsh+iLUFs/tnlJWD2GmQi01vSHHVEnw=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Insufficient permissions for /var/lib/kula, falling back to /homeless-shelter/.kula
  doCheck = false;

  meta = {
    description = "Lightweight, self-contained Linux® server monitoring tool";
    homepage = "https://github.com/c0m4r/kula";
    changelog = "https://github.com/c0m4r/kula/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "kula";
  };
})
