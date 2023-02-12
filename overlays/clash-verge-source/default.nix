{ lib
, stdenv
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, rustPlatform
, dbus
, freetype
, openssl
, pkg-config
, webkitgtk
, libcap
, libappindicator-gtk3
, libayatana-appindicator
, clash-premium
}:

# WIP!!!
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=clash-verge
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
    #   hash = "sha256-SesccsQa9f7KVlZcVss2sGIuTbz5+xy/sHdwaufEuek=";
    # };

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    buildPhase = ''
      runHook preBuild

      # export HOME=$(mktemp -d)
      # yarn run check
      # yarn --offline build
      yarn tauri build
      # cp -r deps/clash-verge $out

      runHook postBuild
    '';

    distPhase = "true";
    # dontInstall = true;

    postBuild = ''
       mkdir -p src-tauri/sidecar
       cp ${lib.getExe clash-premium} src-tauri/sidecar/clash-x86_64-unknown-linux-gnu
    '';
  };
in
rustPlatform.buildRustPackage rec {
  inherit version src pname;

  sourceRoot = "source/src-tauri";

  cargoHash = "sha256-BhFGGUxLFhAB8WuZJmUuGOWRs3DnkVPCGbWdMBCdCYA=";

  # Copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  # postPatch = ''
  #   mkdir -p frontend-build
  #   cp -R ${frontend-build}/src frontend-build
  #   substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'

  #   mkdir -p src-tauri/sidecar
  #   cp ${lib.getExe clash-premium} src-tauri/sidecar/clash-x86_64-unknown-linux-gnu
  # '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    freetype
    webkitgtk
  ];

  # Skip one test that fails ( tries to mutate the parent directory )
  # checkFlags = [ "--skip=test_file_operation" ];


  meta = with lib; {
    description = "A Clash GUI based on tauri. Supports Windows, macOS and Linux";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
