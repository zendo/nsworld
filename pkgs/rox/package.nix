#/*
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  alsa-lib,
  glib-networking,
  libayatana-appindicator,
  libglvnd,
  vulkan-loader,
  wayland,
}:
let
  libs = [
    libglvnd
    vulkan-loader
    wayland
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rox";
  version = "1.30.6";

  src = fetchurl {
    url = "https://github.com/zealsprince/rox/releases/download/v${finalAttrs.version}/rox_${finalAttrs.version}_amd64.deb";
    hash = "sha256-xIVmwg2vn/R52Nfk0tWc7Gs0xn/R4YPvTww8PJlDaLo=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    glib-networking
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ]
  ++ libs;

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "If Foobar2000 was made in the current year";
    homepage = "https://rox.music";
    downloadPage = "https://github.com/zealsprince/rox";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "rox";
  };
})
#*/
/*
  {
    lib,
    rustPlatform,
    fetchFromGitHub,
    fetchCrate,
    cmake,
    pkg-config,
    alsa-lib,
    fontconfig,
    freetype,
    libglvnd,
    libx11,
    libxcb,
    libxkbcommon,
    openssl,
    vulkan-loader,
    wayland,
    zlib,
    libprojectm,

    lastfmApiKey ? "88e26d5b524f6a7b61734350d32afc32",
    lastfmApiSecret ? "51ece542496dc6b5641eb3feb2735f3b",
    discordApplicationId ? "1531533372051030036",
    acoustidClientKey ? "NM7UnN9N7Z",
  }:

  let
    gpui = fetchCrate {
      pname = "gpui";
      version = "0.2.2";
      hash = "sha256-pZU54Gyy9YtQi7duvgosWPm/uBCafXjYV2AMoIVzhzo=";
    };

    gpuiComponent = fetchCrate {
      pname = "gpui-component";
      version = "0.5.1";
      hash = "sha256-GbvU4Cun1rvEZNpKSK1GHslXgAgYBbSI1LI+9ZxkIiY=";
    };

    projectm = fetchFromGitHub {
      owner = "projectM-visualizer";
      repo = "projectm";
      rev = "88f23c76743a38c6d8456a8c354c62186270f661";
      fetchSubmodules = true;
      hash = "sha256-vWVT5SF6SueykBX0NM5LLJGwWzxXsXzis2uMorBmN9w=";
    };

    runtimeLibs = [
      vulkan-loader
      wayland
      libxkbcommon
      libglvnd
    ];
  in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "rox";
    version = "1.30.2";

    src = fetchFromGitHub {
      owner = "zealsprince";
      repo = "rox";
      tag = "v${finalAttrs.version}";
      hash = "sha256-SJFOpZPoUHfc1fEk3mxAjwdAgFl5lgBumnQ02MQUE2Q=";
    };

    cargoHash = "sha256-mmHbCfjUD6UzOdBNpl84dbAheBfZqtZv/w2o9rzbLWY=";

    cargoBuildFlags = [
      "--package"
      "rox"
      "--package"
      "rox-mcp"
    ];

    env = {
      LASTFM_API_KEY = lastfmApiKey;
      LASTFM_API_SECRET = lastfmApiSecret;
      DISCORD_APPLICATION_ID = discordApplicationId;
      ACOUSTID_CLIENT_KEY = acoustidClientKey;
    };

    nativeBuildInputs = [
      pkg-config
      # libprojectM build
      cmake
    ];

    buildInputs = [
      openssl
      libxcb
      libx11
      fontconfig
      freetype
      zlib
      alsa-lib
    ]
    ++ runtimeLibs;

    # Upstream vendor scripts modify the source tree in place. Recreate their
    # vendor trees here because Cargo requires the GPUI path patches, while
    # rox-milkdrop-sys expects ProjectM at build time.
    postPatch = ''
      mkdir -p vendor
      cp -r ${gpui} vendor/gpui
      cp -r ${gpuiComponent} vendor/gpui-component
      cp -r ${projectm} vendor/projectm
      chmod -R u+w vendor

      # Patches must be applied in the same order as upstream vendor scripts.
      export LC_ALL=C
      for p in ${finalAttrs.src}/patches/gpui/*.patch; do
        patch -p1 -F0 -d vendor/gpui < "$p"
      done
      for p in ${finalAttrs.src}/patches/gpui-component/*.patch; do
        patch -p1 -F0 -d vendor/gpui-component < "$p"
      done
      for p in ${finalAttrs.src}/patches/projectm/*.patch; do
        patch -p1 -F0 -d vendor/projectm < "$p"
      done
    '';

    postFixup = ''
      patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/rox
    '';

    postInstall = ''
      install -Dm644 crates/rox/assets/app/rox.desktop $out/share/applications/rox.desktop
      install -Dm644 crates/rox/assets/app/rox-music.svg $out/share/icons/hicolor/scalable/apps/rox.svg
      install -Dm644 crates/rox/assets/app/rox.png $out/share/pixmaps/rox.png
      install -Dm644 crates/rox/assets/app/rox.metainfo.xml $out/share/metainfo/rox.metainfo.xml
    '';

    meta = {
      description = "If Foobar2000 was made in the current year";
      homepage = "https://rox.music";
      downloadPage = "https://github.com/zealsprince/rox";
      license = lib.licenses.agpl3Only;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ omp-deepseek-flash ];
      mainProgram = "rox";
    };
  })
*/
