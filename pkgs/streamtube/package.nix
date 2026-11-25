{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  mpv-unwrapped,
  vulkan-loader,
  libglvnd,
  wayland,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxrandr,
  libxi,
  fontconfig,
  freetype,
  openssl,
  zstd,
  sqlite,
  yt-dlp,
  ffmpeg-headless,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "streamtube";
  version = "0.7.5-alpha";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Avaneesh-Inamdar";
    repo = "Stream-Tube-Desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dFdKJsVfyqT3YhgYrIJPv6dwuFzGX/Qp8Xuyg7+hbdo=";
  };

  cargoHash = "sha256-zK3EujtYhCGnJW4Iyo4kLbDcvp3pKV3gMgsDrLuGm3Q=";

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    wayland
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxrandr
    libxi
    vulkan-loader
    openssl
    zstd
    sqlite
  ];

  # The crate tests hit the network and the user's store.
  doCheck = false;

  # libmpv and the GPU stack are dlopen()ed at run time, so they only need to
  # be reachable through LD_LIBRARY_PATH.
  postInstall = ''
    install -Dm644 packaging/linux/streamtube.desktop \
      $out/share/applications/streamtube.desktop
    install -Dm644 packaging/linux/io.github.avaneesh_inamdar.StreamTube.metainfo.xml \
      $out/share/metainfo/io.github.avaneesh_inamdar.StreamTube.metainfo.xml
    install -Dm644 assets/logo.png \
      $out/share/icons/hicolor/256x256/apps/streamtube.png
    install -Dm644 assets/logo.svg \
      $out/share/icons/hicolor/scalable/apps/streamtube.svg

    # yt-dlp resolves the stream URLs; the app falls back to its own extractor
    # without it, but downloads need ffmpeg.
    wrapProgram $out/bin/streamtube \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          mpv-unwrapped
          vulkan-loader
          libglvnd
          wayland
          libxkbcommon
          libx11
          libxcb
          libxcursor
          libxrandr
          libxi
          fontconfig
          freetype
          openssl
          zstd
          sqlite
        ]
      }" \
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ffmpeg-headless ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native YouTube desktop client in Rust + GPUI with SponsorBlock, DeArrow and local subscriptions";
    homepage = "https://github.com/Avaneesh-Inamdar/Stream-Tube-Desktop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "streamtube";
    platforms = lib.platforms.linux;
  };
})
