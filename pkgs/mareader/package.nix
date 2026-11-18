{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  sqlite,
  zstd,
  oniguruma,
  speechd,
  alsa-lib,

  fontconfig,
  freetype,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  libxkbcommon,
  dbus,
  wayland,
  vulkan-loader,
  nix-update-script,
}:
let
  # winit, wgpu, glutin and fontique reach for these with dlopen, so nothing
  # links them and they need a search path at run time.
  dlopenedLibs = [
    fontconfig # fontique
    freetype
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    libxkbcommon # winit
    dbus
    wayland
    vulkan-loader # wgpu
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mareader";
  version = "0.0.7";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "codewiththiha";
    repo = "mareader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWuM5f60/ASqyJk32q3P8gGuuuzHPzMzT98nT3b+HGQ=";
  };

  # Three workspace crates live in git repos, not on crates.io, so each locked
  # rev needs its own tree hash. The rest is plain crates.io tarballs.
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${finalAttrs.src}/Cargo.lock";
    outputHashes = {
      "ai-pool-0.4.0" = "sha256-irWWIvyXLaaD2HZgTz/NTS+C9cjUaAyCEh6Wn+sX9eA=";
      "cefr-0.3.0" = "sha256-dn78fdCdIiOGIvuLBEZlBtP+zlWtDbeG5riEae9x96M=";
      "fm-bridge-0.2.0" = "sha256-QzKxuN+DYRUcB9G26zgpfpWXFmjMz9vD5DgQVWWtneA=";
    };
  };

  cargoBuildFlags = [
    "-p"
    "mareader"
    "-p"
    "mareader-cli"
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook # speech-dispatcher-sys binds libspeechd headers
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    sqlite
    zstd # parquet and the cefr crate pull in zstd-sys, which links the C library
    oniguruma # nlprule's sentence splitter, through onig_sys
    speechd # the system voices, through libspeechd
    alsa-lib # cpal
  ]
  ++ dlopenedLibs;

  postPatch = ''
    # rust-toolchain.toml asks rustup for a toolchain and a wasm target; the
    # build uses the nixpkgs rustc, which is already that version.
    rm rust-toolchain.toml

    # ai-pool splices the workspace README into its crate docs, but vendoring a
    # git dependency copies only the crate directory, so that file is absent.
    substituteInPlace $cargoDepsCopy/ai-pool-0.4.0/src/lib.rs \
      --replace-fail '#![doc = include_str!("../../../README.md")]' ""
  '';

  postInstall = ''
    install -Dm644 apps/mareader/icons/128x128.png \
      $out/share/icons/hicolor/128x128/apps/mareader.png
    install -Dm644 apps/mareader/icons/32x32.png \
      $out/share/icons/hicolor/32x32/apps/mareader.png
  '';

  # Upstream's tests are UI tests: they drive a real wgpu surface through
  # egui_kittest and read fixture book files off the checkout.
  doCheck = false;

  # The dlopened libraries never land in the ELF, so neither the automatic
  # RUNPATH nor nix's patching covers them.
  postFixup = ''
    wrapProgram $out/bin/mareader \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath dlopenedLibs}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "mareader";
      desktopName = "Mareader";
      comment = "Reader for PDFs and EPUBs";
      exec = "mareader %F";
      icon = "mareader";
      categories = [
        "Office"
        "Viewer"
      ];
      mimeTypes = [
        "application/pdf"
        "application/epub+zip"
        "text/plain"
        "text/markdown"
      ];
      startupWMClass = "mareader";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reader for PDFs and EPUBs, with a four-pane workspace, notes and read-aloud";
    homepage = "https://github.com/codewiththiha/mareader";
    changelog = "https://github.com/codewiththiha/mareader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mareader";
  };
})
