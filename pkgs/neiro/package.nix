{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  pipewire,
  ffmpeg-headless,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neiro";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "wolf-yuan";
    repo = "neiro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LZrC1BFcQgqtPEYtvN7RKSoTgzA7NvHC0C3yBn/Jj8M=";
  };

  cargoHash = "sha256-9v8xZLit/vrPjUSwdlVQtOuOw3jPdeDBJaS3+7/6Bck=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ pipewire ];

  nativeCheckInputs = [ ffmpeg-headless ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Laptop speaker enhancement for Linux, using your laptop's own Dolby tuning";
    homepage = "https://gitlab.com/wolf-yuan/neiro";
    changelog = "https://gitlab.com/wolf-yuan/neiro/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "neiro";
  };
})
