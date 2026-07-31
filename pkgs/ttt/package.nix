{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cOidwINNhDhizEE2+M9+OiKWFMmFkqRfrIdGvV4NQs8=";
  };

  vendorHash = "sha256-tEwXHf0tWtI8dP2trnVoWm9hdV/ORQu4s2EyQN6qAtc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/ttt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Text Tool — an IDE that lives in your terminal";
    homepage = "https://tttedit.dev/";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
