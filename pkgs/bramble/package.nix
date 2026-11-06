{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  pkg-config,
  wrapGAppsHook3,
  webkitgtk_4_1,
  openssl,
  dbus,
  glib-networking,
  libayatana-appindicator,
  librsvg,
  xdotool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bramble";
  version = "0.15.0-desktop";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "flythenimbus";
    repo = "bramble";
    tag = finalAttrs.version;
    hash = "sha256-s9BOmcOQiM0H+sgwzpRiZWaus8Voj9mzN3uT0hWvV/Q=";
  };

  cargoHash = "sha256-Za6ufFhcRumaYr1LWEwjibvNNu780NgTVymXmg9bQ20=";

  cargoRoot = "clients/desktop/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-0aNaXtXdtdMaPtk/Gmid626C+QM5FammjVZhBrkM9ms=";
  };

  postPatch = ''
    # Updater artifacts are signed at bundle time and there is no key here, which would fail the
    # build. Nothing is lost: this install cannot self-update anyway, and an unsigned updater
    # archive is worse than none.
    substituteInPlace clients/desktop/src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pnpm_11
    pnpmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    webkitgtk_4_1
    openssl
    dbus # the Secret Service tier of the credential store
    glib-networking
    libayatana-appindicator # the tray
    librsvg
    xdotool # the global shortcut
  ];

  # The proxy ships as the staged sidecar (stage-proxy.mjs, run by beforeBuildCommand). If staging
  # did not run, build.rs's empty placeholder is what lands here: a browser link that does nothing.
  postInstall = ''
    test -s "$out/bin/bramble-proxy" || {
      echo "bramble-proxy is missing or empty: stage-proxy.mjs did not run" >&2
      exit 1
    }
  '';

  # Autostart records this rather than current_exe(), the wrapped binary, which starts without
  # the environment set here.
  preFixup = ''
    gappsWrapperArgs+=(--set BRAMBLE_LAUNCHER "$out/bin/bramble-desktop")
  '';

  postFixup = ''
    # libappindicator-sys loads AppIndicator dynamically with dlopen(),
    # so add it to the binary's RUNPATH.
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        libayatana-appindicator
      ]
    }" "$out/bin/.bramble-desktop-wrapped"
  '';

  # The crate's own tests need no display and are worth running here, but they are the shell's,
  # not the workspace's: `pnpm test` belongs to CI.
  doCheck = false;

  meta = {
    description = "Offline-first password manager with direct device-to-device sync";
    homepage = "https://bramble.sh";
    downloadPage = "https://github.com/flythenimbus/bramble";
    license = lib.licenses.gpl3Only;
    mainProgram = "bramble-desktop";
    platforms = lib.platforms.linux;
  };
})
