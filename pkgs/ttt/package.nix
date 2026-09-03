{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-30LtJQvNDuHZiZULr2ySsG0itufcCMAUaaKkg6X9lFA=";
  };

  vendorHash = "sha256-QKunMv+rv+a4ps+yXZVxr/MTOkp6c8mslH2BsHozIsY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal text editor IDE.";
    homepage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
