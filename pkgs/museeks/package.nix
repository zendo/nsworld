{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_11,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  jq,
  moreutils,
  alsa-lib,
  dbus,
  glib-networking,
  gst_all_1,
  gtk3,
  librsvg,
  libsecret,
  webkitgtk_4_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "museeks";
  version = "0.23.4";
  __structuredAttrs = true;

  # The latest tag, 0.23.4, predates the Tauri migration; master is the
  # current Tauri 2 application.
  src = fetchFromGitHub {
    owner = "martpie";
    repo = "museeks";
    rev = "7163f6019a3184043c06352caeec0ed1bf6ccff5";
    hash = "sha256-A4lwilLEHRrtfUVq6VxPNur1/0+9lQsmFv92zyqbnfw=";
  };

  cargoHash = "sha256-LeDppG5RW3nqqTym5QSuNxGAXrRTOeIqe++rO3UZ+zI=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-xKIJ0IULc+EWFlIV3q8oTgn1CG4qKZVy/Fr4g+LKBU8=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  postPatch = ''
    # Build the frontend once, from preBuild; Tauri must not run vp again.
    jq 'del(.build.beforeBuildCommand) | .bundle.createUpdaterArtifacts = false' \
      src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pnpmConfigHook
    pnpm_11
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    dbus
    glib-networking
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk3
    librsvg
    libsecret
    webkitgtk_4_1
  ];

  preBuild = ''
    pnpm run build
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple, clean, and cross-platform music player";
    homepage = "https://github.com/martpie/museeks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "museeks";
    platforms = lib.platforms.linux;
  };
})
