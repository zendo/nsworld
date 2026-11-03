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

  # Upstream keeps the volume snapshot in $XDG_RUNTIME_DIR (tmpfs, wiped on
  # reboot) and deletes it on exit, so a reboot always comes back at the
  # pinned speaker volume (hw_volume, 100% by default). Keep it in
  # ~/.local/state/neiro/ and keep it across runs instead.
  postPatch = ''
    substituteInPlace src/daemon.rs \
      --replace-fail 'ipc::socket_path().with_file_name("neiro.restore.json")' \
        'let dir = dirs::state_dir()
        .or_else(|| dirs::home_dir().map(|h| h.join(".local/state")))
        .unwrap_or_else(std::env::temp_dir)
        .join("neiro");
    let _ = std::fs::create_dir_all(&dir);
    dir.join("restore.json")' \
      --replace-fail 'let _ = std::fs::remove_file(restore_path());' \
        '// keep the snapshot: it must survive reboots (see postPatch)'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Laptop speaker enhancement for Linux, using your laptop's own Dolby tuning";
    homepage = "https://gitlab.com/wolf-yuan/neiro";
    changelog = "https://gitlab.com/wolf-yuan/neiro/-/releases/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "neiro";
  };
})
