{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  jq,
  moreutils,
  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  webkitgtk_4_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zfiletimemachine";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TheHolyOneZ";
    repo = "ZFileTimeMachine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vrPUzKH/Vf9qUC914ZPpa8vclFLJmfK8cOZKdSPLEgw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-aGimEKX6mcyKmcUP+GbKWtIORS1XrKbnXrPI4rkomL8=";
  };

  cargoHash = "sha256-b1VpMIDAz0A+rqk1dH7V4m1JBjimJyTN1RYvSKEv5jQ=";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pnpmConfigHook
    pnpm_10
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    libayatana-appindicator
    libsoup_3
    webkitgtk_4_1
  ];

  postPatch = ''
    # Don't run the frontend build twice, and disable Tauri's updater
    # artifact signing (the updater plugin is not enabled upstream).
    jq '
      del(.build.beforeBuildCommand) |
      .bundle.createUpdaterArtifacts = false
    ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    # libappindicator-sys dlopens this library, which autoPatchelf cannot see.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  preBuild = ''
    pnpm run build
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic, private version history for any folder";
    downloadPage = "https://github.com/TheHolyOneZ/ZFileTimeMachine";
    homepage = "https://zsync.eu/zftm/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "zfiletimemachine";
  };
})
