{ lib
, mkYarnPackage
, fetchFromGitHub
, electron
}:
# WIP!!!
mkYarnPackage rec {
  pname = "nightpdf";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "Lunarequest";
    repo = "NightPDF";
    rev = "v${version}";
    hash = "sha256-e15Xvf+9oR8kKyK+BkzSyWk4unuEdICcAsaRv6dpbic=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  buildPhase = ''
    runHook preBuild
    export HOME=$(mktemp -d)
    # export NODE_OPTIONS=--openssl-legacy-provider
    # ln -s $src/postcss.config.js postcss.config.js
    OUTPUT_DIR=$out yarn --offline dist
    runHook postBuild
  '';
  distPhase = "true";
  dontInstall = true;
  dontFixup = true;

  nativeBuildInputs = [
  ];

  buildInputs = [
  ];

  installPhase = ''
    runHook preInstall

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/${pname}" \
      # --add-flags "$out/share/micropad" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hin
t=to --enable-features=WaylandWindowDecorations}}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Previews for lf file manager";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
