{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  mkYarnPackage,
  buildGoModule,
  makeWrapper,
  v2ray,
  v2ray-geoip,
  v2ray-domain-list-community,
  symlinkJoin,
}: let
  pname = "v2raya";
  version = "1.5.9.1698.1";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "v${version}";
    hash = "sha256-h0ZYp/QY+UhQmhCiRkUAGy9zlkmDY7h+QxNzYvweJz0=";
  };

  # cat pkgs/development/tools/continuous-integration/woodpecker/frontend.nix
  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/gui";
    packageJSON = ./package.json;
    offlineCache = fetchYarnDeps {
      yarnLock = "${src}/gui/yarn.lock";
      # hash = "....";
    };
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
  vendorSha256 = "sha256-88tHCnx6qEsRHm5xNyssRL+fh+nsVeWTEqCPEZM9zX0=";
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
