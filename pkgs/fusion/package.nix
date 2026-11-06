{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  pnpm_10,
  nodejs,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "fusion";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "0x2E";
    repo = "fusion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C37NsdddzSgpoj+/+k1EcVVInXDu4REBvhGYGgYHwuE=";
  };

  vendorHash = "sha256-kemQKSbqFj5Z6unZGjPGKW718DeH2IJXsdZOQmBCiJA=";

  modRoot = "backend";
  subPackages = [ "cmd/fusion" ];
  env.CGO_ENABLED = "0";

  frontend = stdenvNoCC.mkDerivation {
    pname = "fusion-frontend";
    inherit (finalAttrs) version src;

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) src;
      pname = "fusion-frontend";
      version = finalAttrs.version;
      sourceRoot = "${finalAttrs.src.name}/frontend";
      pnpm = pnpm_10;
      fetcherVersion = 4;
      hash = "sha256-dBokDkDJd31fyi9MGQa9QXU6gwypgB4az+JnMJD0j24=";
    };
    pnpmRoot = "frontend";

    nativeBuildInputs = [
      nodejs
      pnpmConfigHook
      pnpmBuildHook
      pnpm_10
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r frontend/dist "$out/dist"
      runHook postInstall
    '';
  };

  preBuild = ''
    rm -rf internal/web/dist
    mkdir -p internal/web/dist
    cp -r ${finalAttrs.frontend}/dist/. internal/web/dist/
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight, self-hosted friendly RSS reader";
    homepage = "https://github.com/0x2E/fusion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "fusion";
    platforms = lib.platforms.linux;
  };
})
