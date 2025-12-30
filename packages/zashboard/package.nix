{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zashboard";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqtKn0zfHfWS8bDM/IhChCu3MGVIt/oEfhpp+4j5UG4=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-KKLH3JzJbNoVHjF4Wz0LjNSR3KFOY7MJbZrBm4ZHD60=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    changelog = "https://github.com/Zephyruso/zashboard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
})
