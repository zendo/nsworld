{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "spor";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "emprcl";
    repo = "spor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fhPn3OxowQmvuBrq1ceZVKkD3MWmHuvUcoSm2q7Kfc8=";
  };

  vendorHash = "sha256-6lGNh6lX8XGP2nVvFXfztu7H+jJAZ1qkIMQjZB2FvTM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Infinite undo for your whole project";
    homepage = "https://github.com/emprcl/spor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "spor";
  };
})
