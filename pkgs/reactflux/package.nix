{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_12,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "reactflux";
  version = "2026.10.24";

  src = fetchFromGitHub {
    owner = "electh";
    repo = "ReactFlux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uiBhnK5Ki/AaPfzbHV/nBpKhtbmKZTtzzTRKhTPqc1k=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = "sha256-lPuvhylaEGLFVcumtuzuILO5P+DIE6y65ZP7/Jkg9FQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_12
  ];

  env = {
    SOURCE_COMMIT = "-";
    SOURCE_COMMIT_DATE = lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version;
  };

  postPatch = ''
    substituteInPlace src/AppNotifications.jsx \
      --replace-fail 'useVersionCheck()' '{ hasUpdate: false, dismissUpdate: () => {} }'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build --base=/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r build $out

    runHook postInstall
  '';

  meta = {
    description = "Simple but Powerful RSS Reader for Miniflux";
    homepage = "https://github.com/electh/ReactFlux";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kurnevsky ];
  };
})
