# Manually updating Breeze
# ------------------------
# 1. Bump `version` below and the source `tag` (vX.Y.Z).
# 2. Recompute the source hash:
#      nix-prefetch-url --unpack \
#        https://github.com/breeze-project-org/Breeze/archive/refs/tags/vX.Y.Z.tar.gz \
#        | xargs nix hash convert --to sri --hash-algo sha256
# 3. Refresh the lock file from the same tag:
#      curl -fsSL \
#        https://raw.githubusercontent.com/breeze-project-org/Breeze/vX.Y.Z/pubspec.lock \
#        | yq -o=json > pubspec.lock.json
# 4. Refresh `gitHashes` for every git package in the lock:
#      jq -r '.packages | to_entries[] | select(.value.source == "git")
#             | [.key, .value.description.url, .value.description["resolved-ref"]]
#             | @tsv' pubspec.lock.json
#    For each line run:
#      nix-prefetch-git --url <url> --rev <rev> | jq -r .hash
# 5. Refresh `cargoHash`: set it to
#      "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
#    and run `nix build .#breeze`; the hash mismatch error reports the correct
#    `got:` value. Put that value back into `cargoHash`.
# 6. If jsDelivr serves new plugin bundles, refresh their hashes with:
#      nix-prefetch-url <bundle-url> \
#        | xargs nix hash convert --to sri --hash-algo sha256
# 7. Verify with `nix build .#breeze` and `./result/bin/breeze`.

{
  lib,
  callPackage,
  # Breeze 3.0.38 requires Flutter 3.50 / Dart 3.14. Use the nixpkgs branch
  # or overlay that provides `flutter350` (nixpkgs PR #587442).
  flutter350,
  fetchFromGitHub,
  webkitgtk_4_1,
  libayatana-appindicator,
  copyDesktopItems,
  makeDesktopItem,
  rustPlatform,
  fetchurl,
  gtk3,
  curl,
  libx11,
  libxi,
  pkg-config,
  zstd,
}:

let
  src = fetchFromGitHub {
    owner = "breeze-project-org";
    repo = "Breeze";
    tag = "v3.0.38";
    hash = "sha256-tMJKVRLKnKYpu4kDckvk/6Z+3u5vp2Cy066rumOETtA=";
  };

  # The Flutter build now uses the `native_toolchain_rust` build hook, which
  # shells out to rustup/cargo. Building the crate here keeps the Nix build
  # offline and lets us hand the already built library to the (patched) hook.
  pluginBundles = {
    jm-comic = fetchurl {
      name = "breeze-plugin-jm-comic.bundle.cjs";
      url = "https://cdn.jsdelivr.net/npm/breeze-plugin-jm-comic@latest/dist/breeze-plugin-jm-comic.bundle.cjs";
      hash = "sha256-g5vYfx5uXeDH6joV2i8cv5mD/1ElIRigtJZbY4w0v48=";
    };
    bika-comic = fetchurl {
      name = "breeze-plugin-bika-comic.bundle.cjs";
      url = "https://cdn.jsdelivr.net/npm/breeze-plugin-bika-comic@latest/dist/breeze-plugin-bika-comic.bundle.cjs";
      hash = "sha256-3o1za/sm7sYFzcMY82qorwFXHxsW/KJ5Ved4UYnAf8M=";
    };
  };

  rustLib = rustPlatform.buildRustPackage {
    pname = "breeze-windcore";
    version = "0.1.0";

    inherit src;
    sourceRoot = "${src.name}/rust";

    cargoHash = "sha256-OYRId2IVb0A+iy4XWSNMZmX5NbGC8tAN0mjXEvAdM3Y=";
    # `host-fronting` is enabled by hook/build.dart upstream.
    cargoBuildFlags = [
      "--features"
      "host-fronting"
    ];

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [ zstd ];

    doCheck = false;

    # build.rs downloads the plugin bundles from jsDelivr at build time. The
    # sandbox has no network, so provide the pinned copies; build.rs falls back
    # to these cached files when the download fails.
    postPatch = ''
      mkdir -p assets
      cp ${pluginBundles.jm-comic} assets/jm-comic.bundle.cjs
      cp ${pluginBundles.bika-comic} assets/bika-comic.bundle.cjs
    '';

    meta = {
      description = "Native Rust library for Breeze";
      homepage = "https://github.com/breeze-project-org/Breeze";
      license = lib.licenses.mpl20;
      platforms = lib.platforms.linux;
    };
  };
in
flutter350.buildFlutterApplication (finalAttrs: {
  pname = "breeze";
  version = "3.0.38";

  inherit src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    objectbox_generator = "sha256-xedRExOdRZw9mdfj5ZSGdGV3q6Kxe8P1Z/Z92KyCKJw=";
    permission_handler_windows = "sha256-XV+botjnM2GSOmWzHmOK8pHG/jZ0rqQQ64tLUjW4msI=";
    tray_manager = "sha256-jxMgVOarzMDg4yuluD2utZ9u659KJr1bY5vuW3VivT4=";
  };

  customSourceBuilders.objectbox_flutter_libs = callPackage ./objectbox_flutter_libs.nix { };

  targetFlutterPlatform = "linux";

  postPatch = ''
    # Replace the hook that invokes rustup/cargo with one that emits the
    # library built by `rustLib`.
    cp ${./prebuilt_hook.dart} hook/build.dart
    substituteInPlace hook/build.dart \
      --replace-fail '__BREEZE_RUST_LIB__' '${rustLib}/lib/libwindcore.so'
  '';

  preBuild = ''
    # Native asset hooks run with a sanitized environment: PATH is preserved,
    # but PKG_CONFIG_PATH is not. Provide a pkg-config shim that restores the
    # search path computed by the stdenv setup hooks.
    mkdir -p pkgconfig-shim
    cat > pkgconfig-shim/pkg-config <<EOF
#!/bin/sh
# restored from the build environment by package.nix
export PKG_CONFIG_PATH="''${PKG_CONFIG_PATH}"
exec ${pkg-config}/bin/pkg-config "\$@"
EOF
    chmod +x pkgconfig-shim/pkg-config
    export PATH="$PWD/pkgconfig-shim:$PATH"
  '';

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [
    webkitgtk_4_1
    libayatana-appindicator
    # nativeapi's build hook probes these with pkg-config.
    gtk3
    # sentry-native's bundled CMake project requires libcurl.
    curl
    libx11
    libxi
  ];

  # libwindcore.so links against libzstd at runtime.
  runtimeDependencies = [ zstd ];

  postInstall = ''
    install -D --mode=0644 asset/image/app-icon.png \
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
