{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  gitMinimal,
  ripgrep,
}:

buildGoModule (finalAttrs: {
  pname = "ttt";
  version = "1.7.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eugenioenko";
    repo = "ttt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LcSmUntNXmw+2jA8NLMgnAKObSlF2wknLinAuJxD5aw=";
  };

  vendorHash = "sha256-+mbwJO7J6t584r3rhPsxj9eVfKFOffoWydKJrFNwA2c=";

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

  meta = {
    description = "Terminal Text Tool: The IDE that lives in your terminal";
    homepage = "http://tttedit.dev";
    downloadPage = "https://github.com/eugenioenko/ttt";
    changelog = "https://github.com/eugenioenko/ttt/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "ttt";
  };
})
