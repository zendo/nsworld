{ lib
, stdenv
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, rustPlatform
, dbus
, freetype
, openssl
, webkitgtk
, libcap
, libappindicator-gtk3
, libayatana-appindicator
}:

# WIP!!!
let
  pname = "clash-verge";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = "clash-verge";
    rev = "v1.2.2";
    hash = "sha256-SesccsQa9f7KVlZcVYN2lGIuTbz5+xy/sHdwaufEuek=";
  };

  frontend-build = mkYarnPackage {
    inherit version src;
    pname = "clash-verge-ui";

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-SesccsQa9f7KVlZcVYN2sGIuTbz5+xy/sHdwaufEuek=";
    };

    packageJSON = ./package.json;

    buildPhase = ''
      export HOME=$(mktemp -d)
      yarn --offline run prebuild
      # cp -r deps/xplorer/out $out
    '';

    distPhase = "true";
    dontInstall = true;
  };
in
rustPlatform.buildRustPackage rec {
  inherit version src pname;

  sourceRoot = "source/src-tauri";

  cargoHash = "sha256-U97V3b/luAsGxSFszwSNu0fvd6PpieDgF1BVECH2pMQ=";

  # Copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  preBuild = ''
    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build
    substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'
  '';

  # nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    freetype
    webkitgtk
    # cmake
  ];

  # Skip one test that fails ( tries to mutate the parent directory )
  checkFlags = [ "--skip=test_file_operation" ];

  # Rename the executable
  postInstall = ''
    mv $out/bin/app $out/bin/clash-verge
  '';

  # nativeBuildInputs = [
  # ];

  # buildInputs = [
  #   openssl
  #   webkitgtk
  #   stdenv.cc.cc
  # ];

  meta = with lib; {
    description = "A Clash GUI based on tauri. Supports Windows, macOS and Linux";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
