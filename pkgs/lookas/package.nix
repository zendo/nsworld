{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  alsa-lib,
  pulseaudio,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lookas";
  version = "1.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rccyx";
    repo = "lookas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ki/pn33lHVz/Kos9AIyCo3ZIUm6L4IpIjwtc7VgcFb0=";
  };

  cargoHash = "sha256-DmhsTfhFvZ7Iyz+xotfnfPTXws6cZfo0esgXWStUDhk=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    alsa-lib
  ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ pulseaudio ]}
  '';

  meta = {
    description = "Psychoacoustic terminal spectrum visualizer";
    homepage = "https://github.com/rccyx/lookas";
    changelog = "https://github.com/rccyx/lookas/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "lookas";
  };
})
