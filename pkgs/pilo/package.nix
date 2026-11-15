{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_11,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  jq,
  moreutils,
  dbus,
  glib-networking,
  libayatana-appindicator,
  librsvg,
  libsoup_3,
  openssl,
  sqlite,
  webkitgtk_4_1,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pilo";
  version = "0.4.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hsingjui";
    repo = "pilo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kS/JX12JoGC21KH+cLZ9+7/zdPEZdoa0V6gTbpm7+4c=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-esLgTgtm1w+xIWqhcocSSo9EeqcMt1xZYPbqRF+ZUvI=";
  };

  cargoHash = "sha256-d1AoA2OHRNWNnvIKUaWnBgqmPNRAgqKwbCT+1WTpWT4=";

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
    dbus
    glib-networking
    libayatana-appindicator
    librsvg
    libsoup_3
    openssl
    sqlite # cargo-setup-hook forces libsqlite3-sys to use pkg-config
    webkitgtk_4_1
  ];

  postPatch = ''
    jq 'del(.build.beforeBuildCommand) | .bundle.createUpdaterArtifacts = false' \
      src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" \
        "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  # The desktop app resolves the bundled server by this exact name, and its
  # build script refuses to produce a release build without the file present.
  serverRuntime =
    {
      "x86_64-unknown-linux-gnu" = "pilo-server-linux-x86_64";
      "aarch64-unknown-linux-gnu" = "pilo-server-linux-aarch64";
    }
    .${stdenv.hostPlatform.rust.rustcTarget}
      or (throw "pilo: no pilo-server runtime for ${stdenv.hostPlatform.rust.rustcTarget}");

  # The release build embeds src-tauri/resources/<runtime> as the local
  # pilo-server sidecar (and its build script fails without it), so build
  # it first from the same vendored sources.
  preBuild = ''
    pnpm run build

    cargo build --offline --profile release \
      -p pilo-server --target ${stdenv.hostPlatform.rust.rustcTarget}
    install -Dm755 target/${stdenv.hostPlatform.rust.rustcTarget}/release/pilo-server \
      src-tauri/resources/${finalAttrs.serverRuntime}
  '';

  # Unit tests are the frontend's and CI's business; the Rust tests here spawn
  # terminals and a pi process that the sandbox cannot provide.
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for the Pi coding agent";
    downloadPage = "https://github.com/hsingjui/pilo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pilo";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
