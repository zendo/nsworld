{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  gitMinimal,
  ripgrep,
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          ripgrep
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal Text Tool: The IDE that lives in your terminal.";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
