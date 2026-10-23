{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  flatpak-extract,
  autoPatchelfHook,
  gtk3,
  alsa-lib,
  sqlite,
  wayland,
  libxkbcommon,
  vulkan-loader,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonora";
  version = "0.44.1";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/sonorahq/sonora/releases/download/v${finalAttrs.version}/sonora-v${finalAttrs.version}-x86_64.flatpak";
    hash = "sha256-3yT4+se27jg3mKiXQzMGJ4s0/Cb2JQt9bkqGUapBK80=";
  };

  nativeBuildInputs = [
    makeWrapper
    flatpak-extract
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    alsa-lib
    sqlite
    libayatana-appindicator
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
    wayland
    libxkbcommon
    vulkan-loader
  ];

  unpackPhase = ''
    runHook preUnpack

    flatpak-extract "$src" --outdir extracted
    cd extracted/files

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp bin/sonora $out/bin/
    cp -r share $out/

    runHook postInstall
  '';

  meta = {
    description = "Native music streaming client built with Rust and GPUI";
    homepage = "https://github.com/sonorahq/sonora";
    changelog = "https://github.com/sonorahq/sonora/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      ofl
      isc
      mit
      asl20
      cc-by-40
      cc0
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "sonora";
  };
})
