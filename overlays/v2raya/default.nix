{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  buildGoModule,
  makeWrapper,
  v2ray,
  v2ray-geoip,
  v2ray-domain-list-community,
  symlinkJoin,
}: let
  pname = "v2raya";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "v${version}";
    sha256 = "sha256-nKUVcrSi69DOrvxqXsYYDWCtkORGyGWlbvLL9ABedUg=";
  };

  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/gui";
    # yarnNix = ./yarn.nix;
    # packageJSON = ./package.json;
    # yarnLock = ./yarn.lock;
    buildPhase = ''
      ln -s $src/postcss.config.js postcss.config.js
      OUTPUT_DIR=$out yarn --offline build
    '';
    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };
in
  buildGoModule {
    inherit pname version;
    src = "${src}/service";
    vendorSha256 = "sha256-ZTqYZ57PUTKauVnqGPIKWg2qsFeDIc3Z2/4mgc8M0Ww=";
    subPackages = ["."];
    nativeBuildInputs = [makeWrapper];
    preBuild = ''
      cp -a ${web} server/router/web
    '';

    postInstall = ''
      wrapProgram $out/bin/v2rayA \
        --prefix PATH ":" "${lib.makeBinPath [v2ray.core]}" \
        --prefix XDG_DATA_DIRS ":" ${symlinkJoin {
        name = "assets";
        paths = [v2ray-geoip v2ray-domain-list-community];
      }}/share
    '';

    meta = with lib; {
      description = "A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
      homepage = "https://github.com/v2rayA/v2rayA";
      mainProgram = "v2rayA";
      license = licenses.agpl3Only;
      maintainers = with lib.maintainers; [shanoaice];
    };
  }
