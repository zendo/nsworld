{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  libpulseaudio,
  pipewire,
  sqlite,
  alsa-lib,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:
let
  libs = [
    libxkbcommon
    vulkan-loader
    wayland
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustle";
  version = "0.4.7";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Fei-xiangShi";
    repo = "Rustle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLoo9XbNsIb0kkPboFoiajhz1X/ltDRJ1wvyqqLGCno=";
  };

  cargoHash = "sha256-hbKsNKpoKFD6wY6A/ihR2JDAahDArKDSwANYmo/xvs8=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    # libpulseaudio
    # pipewire
    sqlite
    alsa-lib
  ]
  ++ libs;

  postFixup = ''
    wrapProgram $out/bin/rustle \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
  '';

  postInstall = ''
    install -Dm644 packaging/linux/life.fxs.rustle.desktop \
      $out/share/applications/life.fxs.rustle.desktop

    install -Dm644 packaging/linux/life.fxs.rustle.metainfo.xml \
      $out/share/metainfo/life.fxs.rustle.metainfo.xml

    install -Dm644 assets/icons/icon_256.png \
      $out/share/icons/hicolor/256x256/apps/life.fxs.rustle.png

    install -Dm644 LICENSE \
      $out/share/licenses/rustle/LICENSE
  '';

  doCheck = false;

  meta = {
    description = "Cross-platform music player with Apple Music-style lyrics, GPU-accelerated rendering, built in Rust";
    homepage = "https://github.com/Fei-xiangShi/Rustle";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "rustle";
  };
})
