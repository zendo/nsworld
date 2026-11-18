{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  flatpak-extract,
  autoPatchelfHook,
  libgcc,
  alsa-lib,
  sqlite,
  libxcb,
  wayland,
  libxkbcommon,
  vulkan-loader,
  libglvnd,
  glib-networking,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sonora";
  version = "0.48.1";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/sonorahq/sonora/releases/download/v${finalAttrs.version}/sonora-v${finalAttrs.version}-x86_64.flatpak";
    hash = "sha256-N+z8E4Al1tC/KdHPvCBueXB+jfkYhvmOSHFUtlLbIRk=";
  };

  nativeBuildInputs = [
    makeWrapper
    flatpak-extract
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc.lib
    alsa-lib
    sqlite
    libxcb
    libxkbcommon
  ];

  runtimeDependencies = [
    libglvnd
    wayland
    vulkan-loader
  ];

  unpackPhase = ''
    flatpak-extract "$src" --outdir extracted
    cd extracted/files
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -a bin/sonora $out/bin/
    cp -a share $out/
  '';

  postFixup = ''
    wrapProgram $out/bin/sonora \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
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
