{
  lib,
  fetchFromGitLab,
  rustPlatform,
  fetchPnpmDeps,
  cargo-tauri,
  pnpmConfigHook,
  pnpm,
  nodejs,
  pkg-config,
  jq,
  moreutils,
  wrapGAppsHook3,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
}:
# Copy from: https://gitlab.com/ArkHost/HelixNotes/-/blob/main/flake.nix
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "helixnotes";
  version = "1.3.6";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "ArkHost";
    repo = "HelixNotes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-06U9404JTZju1fjMtzkncWjf2zuww1P+oDLcZak5XkA=";
  };

  cargoHash = "sha256-t03bO221qKv0EL3h2e12G2qfKfaRW7BMYqTgKcYRYp8=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-jBPXRMh9w1Ph0d1XsjJZRABYDh0mJWiY7WCB7i9Wym0=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    pnpm
    nodejs
    pkg-config
    jq
    moreutils
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    libayatana-appindicator
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  postPatch = ''
    # Disable upstream updates.
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    # Fix the hardcoded library path in libappindicator-sys.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  meta = {
    description = "Local Markdown note-taking app. No cloud, no account, no telemetry";
    homepage = "https://helixnotes.com";
    downloadPage = "https://gitlab.com/ArkHost/HelixNotes";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "helixnotes";
  };
})
