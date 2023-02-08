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
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = "clash-verge";
    rev = "v1.2.3";
    hash = "sha256-epeC5rUq8V3m/8UgvqBfTmfkzsoEDJ3u0SauWZfrsa8=";
  };

  frontend-build = mkYarnPackage {
    inherit version src;
    pname = "clash-verge-ui";

    # offlineCache = fetchYarnDeps {
    #   yarnLock = src + "/yarn.lock";
    #   hash = "sha256-SesccsQa9f7KVlZcVsN2sGIuTbz5+xy/sHdwaufEuek=";
    # };

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn run check
      # yarn --offline build
      # ls ./
      # cp -r deps/clash-verge/out $out

      # yarn --offline run prebuild
      # cp -r deps/xplorer/out $out

      runHook postBuild
    '';

    distPhase = "true";
    dontInstall = true;
  };
in
rustPlatform.buildRustPackage rec {
  inherit version src pname;

  sourceRoot = "source/src-tauri";

  cargoHash = "sha256-U97V3b/luAssxSFszwSNu0fvd6PpieDgF1BVECH2pMQ=";

  # Copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  preBuild = ''
    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build
    # substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'
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
