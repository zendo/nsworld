{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  alsa-lib,
  pipewire,
  sqlite,
  aws-lc,
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
  # iced/winit/wgpu/fontique resolve these through dlopen, so they never show
  # up in the ELF and neither patchelf nor the automatic RUNPATH covers them.
  dlopenedLibs = [
    fontconfig
    freetype
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    libxkbcommon
    dbus
    wayland
    vulkan-loader
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustle";
  version = "0.5.7";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Fei-xiangShi";
    repo = "Rustle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GckTHUBeG3tVsmHWyes/IXOnGjcTbs4heVoLUEyUp/E=";
  };

  cargoHash = "sha256-Mx0oDGa99ppQCt34mH3L3/Wfb8v7no7BhNxsxhlrMbI=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook # pipewire-sys
    makeWrapper
  ];

  buildInputs = [
    alsa-lib # rodio -> cpal
    pipewire # rustle-audio talks to PipeWire directly
    sqlite # sqlx
    aws-lc # rustls pulls aws-lc-sys, which the crate overrides build against the system copy
  ];

  # The lyric and artwork tests shape text through cosmic-text and build a
  # reqwest client, so they need installed system fonts and a CA bundle that the
  # build sandbox does not have.
  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/linux/life.fxs.rustle.desktop \
      $out/share/applications/life.fxs.rustle.desktop
    install -Dm644 packaging/linux/life.fxs.rustle.metainfo.xml \
      $out/share/metainfo/life.fxs.rustle.metainfo.xml
    install -Dm644 assets/icons/icon_256.png \
      $out/share/icons/hicolor/256x256/apps/life.fxs.rustle.png
  '';

  postFixup = ''
    wrapProgram $out/bin/rustle \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath dlopenedLibs}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform music player with Apple Music-style lyrics and GPU-accelerated rendering, built in Rust";
    homepage = "https://github.com/Fei-xiangShi/Rustle";
    changelog = "https://github.com/Fei-xiangShi/Rustle/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rustle";
    platforms = lib.platforms.linux;
  };
})
