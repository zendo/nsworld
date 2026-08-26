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
  version = "1.3.4";
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "ArkHost";
    repo = "HelixNotes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1X45Ipq/y/EK8JBUWKjg6pf5fUEJHOHw6GfIQofNu6c=";
  };

  cargoHash = "sha256-P0iXImWYKYPxVj7q2JSuDmd8JvjcKW4DzFUzXeUQZPk=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 4;
    hash = "sha256-odUNKO2D50DG+VpuoTEo5FLMYy5pQSHQBtfHJrhJt78=";
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

  # Deactivate the upstream update mechanism
  postPatch = ''
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
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

/*
  {
    lib,
    stdenv,
    fetchurl,
    dpkg,
    wrapGAppsHook3,
    autoPatchelfHook,
    udev,
    webkitgtk_4_1,
    glib-networking,
    libayatana-appindicator,
  }:

  stdenv.mkDerivation (finalAttrs: {
    pname = "helixnotes";
    version = "1.3.4";

    src = fetchurl {
      url = "https://download.helixnotes.com/releases/v${finalAttrs.version}/HelixNotes_${finalAttrs.version}_amd64.deb";
      hash = "sha256-IiIKelur40N7EGINP+6XuVUbdKf2RCz+fALg+ixmiq0=";
    };

    nativeBuildInputs = [
      dpkg
      wrapGAppsHook3
      autoPatchelfHook
    ];

    buildInputs = [
      webkitgtk_4_1
      glib-networking
      (lib.getLib stdenv.cc.cc)
    ];

    runtimeDependencies = [
      (lib.getLib udev)
      libayatana-appindicator
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp -r usr/* $out
    '';

    meta = {
      description = "Local Markdown note-taking app. No cloud, no account, no telemetry";
      homepage = "https://helixnotes.com";
      downloadPage = "https://gitlab.com/ArkHost/HelixNotes";
      license = lib.licenses.agpl3Only;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      maintainers = with lib.maintainers; [ zendo ];
      mainProgram = "helixnotes";
    };
  })
*/
