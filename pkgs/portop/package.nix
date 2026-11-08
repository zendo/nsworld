{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "portop";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "padovanl";
    repo = "portop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rKojm88W+3t46RpyPjicuHtxTrnZmrhrRw+HhESti+I=";
  };

  vendorHash = "sha256-rx7CH/P9gm5fq+91sFs07qz+ElI06aUzNTptMfWRS4w=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/padovanl/portop/internal/cli.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Htop for your ports, and manage it on TUI, Web or Cockpit";
    homepage = "https://github.com/padovanl/portop";
    changelog = "https://github.com/padovanl/portop/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "portop";
  };
})
