{
  lib,
  fetchFromGitHub,
  nix-update-script,
  nodejs,
  pnpm,
  stdenv,
}:
# https://github.com/NixOS/nixpkgs/pull/380665
stdenv.mkDerivation (finalAttrs: {
  pname = "zashboard";
  version = "1.73.1";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fOwxC71qrITC6/xesMGosj01SG+0SP2B5s3maqme/yw=";
  };

  nativeBuildInputs = [
    pnpm.configHook
    nodejs
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-XvR0791aSgmCTYlM5EImejGYnOwsPyxpdUTTbaIJBdM=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    changelog = "https://github.com/Zephyruso/zashboard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
})
