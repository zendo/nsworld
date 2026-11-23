{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  fontconfig,
  freetype,
  zstd,
  sqlite,
  aws-lc,
  rust-jemalloc-sys,
  alsa-lib,
  libxkbcommon,
  wayland,
  libxcb,
  libglvnd,
  vulkan-loader,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kuana";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "berkayakin";
    repo = "kuana-editor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xK3UCacxAyL8g0okS8sfdtw+VC+tSO1fmpvgo6zzv+A=";
  };

  cargoHash = "sha256-v8hNJaa1nw2S2mOIxmw8DHMUDRNZGlyrZqInYWB8mss=";

  # The editor, plus the headless server it copies to machines it reaches over SSH.
  cargoBuildFlags = [
    "-p"
    "kuana"
    "-p"
    "kuana-server"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  # GPUI's Linux backend: font rendering, Wayland/X11 windows and Vulkan.
  buildInputs = [
    fontconfig
    freetype
    zstd
    # rusqlite asks upstream for its bundled copy; Nix's cargo hook points it at
    # the system SQLite instead.
    sqlite
    alsa-lib
    # rustls, which the database and SSH clients bring in, signs with AWS-LC;
    # nixpkgs' crate override links that instead of a bundled copy.
    aws-lc
    # wasmtime's allocator; the `_rjem_`-prefixed build sets JEMALLOC_OVERRIDE
    # so jemalloc-sys links it instead of compiling its own copy.
    rust-jemalloc-sys
    libxkbcommon
    wayland
    libxcb
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = "1";
    # Building without it keeps the updater off: a Nix-installed Kuana must not
    # overwrite itself.
    KUANA_RELEASE = "0";
  };

  # Tests open windows on a GPU.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    bin=target/${stdenv.hostPlatform.rust.cargoShortTarget}/release
    install -Dm755 $bin/kuana $out/bin/kuana
    install -Dm755 $bin/kuana-server $out/bin/kuana-server

    install -Dm644 assets/app-icon/linux/dev.kuana.editor.desktop \
      $out/share/applications/dev.kuana.editor.desktop
    for icon in assets/app-icon/linux/hicolor/*/apps/*.png; do
      install -Dm644 "$icon" "$out/share/icons/hicolor/$(basename "$(dirname "$(dirname "$icon")")")/apps/dev.kuana.editor.png"
    done

    runHook postInstall
  '';

  # GPUI loads its Wayland client, Vulkan and GL at run time, so they are not in
  # the binary's RPATH and have to be on LD_LIBRARY_PATH.
  postFixup = ''
    wrapProgram $out/bin/kuana \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          wayland
          libglvnd
          vulkan-loader
        ]
      }"
  '';

  meta = {
    description = "Small, fast GPU-rendered code editor";
    homepage = "https://github.com/berkayakin/kuana-editor";
    license = with lib.licenses; [
      mit
      asl20
      ofl
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "kuana";
  };
})
