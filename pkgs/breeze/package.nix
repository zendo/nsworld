# Updating: bump `version` and the source `tag`, then refresh
#   src.hash          - nix hash path <extracted tarball of the tag>
#   pubspec.lock.json - yq -o=json pubspec.lock from the same tag
#   gitHashes         - nix-prefetch-git --url <url> --rev <rev>, for every
#                       `source: git` entry in the lock
#   cargoHash         - set to sha256-AAAA..., build, paste the reported `got:`
#   pluginBundles     - nix-prefetch-url <bundle-url>, when jsDelivr ships new ones

{
  lib,
  flutter350,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  sqlite,
  zstd,
  patchelf,
  webkitgtk_4_1,
  libayatana-appindicator,
  gtk3,
  curl,
  libx11,
  libxi,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  src = fetchFromGitHub {
    owner = "breeze-project-org";
    repo = "Breeze";
    tag = "v3.1.0";
    hash = "sha256-2dC7HdNfpnTxojamMfsoVZN/WcE7t0pl54lkf5NWfu0=";
  };

  # build.rs downloads these bundles from jsDelivr while compiling the crate.
  pluginBundles = {
    jm-comic = fetchurl {
      name = "jm-comic.bundle.cjs";
      url = "https://cdn.jsdelivr.net/npm/breeze-plugin-jm-comic@latest/dist/breeze-plugin-jm-comic.bundle.cjs";
      hash = "sha256-g5vYfx5uXeDH6joV2i8cv5mD/1ElIRigtJZbY4w0v48=";
    };
    bika-comic = fetchurl {
      name = "bika-comic.bundle.cjs";
      url = "https://cdn.jsdelivr.net/npm/breeze-plugin-bika-comic@latest/dist/breeze-plugin-bika-comic.bundle.cjs";
      hash = "sha256-3o1za/sm7sYFzcMY82qorwFXHxsW/KJ5Ved4UYnAf8M=";
    };
  };

  # `hook/build.dart` shells out to cargo, which the sandbox cannot do, so the
  # crate is built here and the hook is dropped again below.
  windcore = rustPlatform.buildRustPackage {
    pname = "breeze-windcore";
    version = "0.1.0";

    inherit src;
    sourceRoot = "${src.name}/rust";

    cargoHash = "sha256-bpE3pZj0ib/aN1sJI+CmNJaG4plyi+piW576ytMDtU0=";
    # Same feature set as hook/build.dart.
    cargoBuildFlags = [
      "--features"
      "host-fronting"
    ];

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      sqlite
      zstd
    ];

    doCheck = false;

    # build.rs falls back to the files already present in assets/ when the
    # download fails, which is always the case offline.
    postPatch = ''
      mkdir -p assets
      cp ${pluginBundles.jm-comic} assets/jm-comic.bundle.cjs
      cp ${pluginBundles.bika-comic} assets/bika-comic.bundle.cjs
    '';

    meta = {
      description = "Native Rust library for Breeze";
      homepage = "https://github.com/breeze-project-org/Breeze";
      license = lib.licenses.mpl20;
    };
  };
in
flutter350.buildFlutterApplication (finalAttrs: {
  pname = "breeze";
  version = "3.1.0";

  inherit src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    permission_handler_windows = "sha256-XV+botjnM2GSOmWzHmOK8pHG/jZ0rqQQ64tLUjW4msI=";
    tray_manager = "sha256-jxMgVOarzMDg4yuluD2utZ9u659KJr1bY5vuW3VivT4=";
  };

  targetFlutterPlatform = "linux";

  postPatch = ''
    # The hook only produces libwindcore.so; ship the one built by `windcore`.
    rm -rf hook
  '';

  nativeBuildInputs = [
    copyDesktopItems
    patchelf
  ];

  preBuild = ''
    # Native asset hooks run with a sanitized environment: PATH survives but
    # PKG_CONFIG_PATH does not, so plugins probing gtk/x11 through pkg-config
    # would fail. Bake the search path into a wrapper on PATH.
    mkdir -p pkgconfig-shim
    printf '#!/bin/sh\nexport PKG_CONFIG_PATH=%s\nexec %s "$@"\n' \
      "$PKG_CONFIG_PATH" ${pkg-config}/bin/pkg-config > pkgconfig-shim/pkg-config
    chmod +x pkgconfig-shim/pkg-config
    export PATH=$PWD/pkgconfig-shim:$PATH
  '';

  buildInputs = [
    webkitgtk_4_1
    libayatana-appindicator
    gtk3
    curl
    libx11
    libxi
  ];

  postInstall = ''
    # The app looks libwindcore.so up through its `$ORIGIN/lib` rpath.
    install -Dm755 ${windcore}/lib/libwindcore.so $out/app/breeze/lib/libwindcore.so
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        sqlite
        zstd
      ]
    } \
      $out/app/breeze/lib/libwindcore.so

    install -Dm644 asset/image/app-icon.png \
      $out/share/icons/hicolor/512x512/apps/breeze.png
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "breeze";
      exec = "breeze";
      icon = "breeze";
      desktopName = "Breeze";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "Graphics"
      ];
      startupWMClass = "breeze";
    })
  ];

  meta = {
    description = "使用 Flutter 构建的漫画阅读器，通过插件提供漫画源支持";
    homepage = "https://github.com/breeze-project-org/Breeze";
    changelog = "https://github.com/breeze-project-org/Breeze/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "breeze";
    platforms = lib.platforms.linux;
  };
})
