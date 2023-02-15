{ lib
, buildNpmPackage
, fetchFromGitHub
, electron
, openssl
, libsecret
, esbuild
, pkg-config
, python3
}:
# WIP!!!
buildNpmPackage rec {
  pname = "thorium-reader";
  version = "2.3.0-alpha.1";

  src = fetchFromGitHub {
    owner = "edrlab";
    repo = pname;
    rev = "latest-linux";
    hash = "sha256-Y2WAzmX2ThBUdBv2qQ8kvhLdFPgpY2kOmfEVC2sbuFM=";
  };

  npmDepsHash = "sha256-p9dXz/aDcXyxewZsW0bnylWTsIf9JVGYyW9+J3dQG4s=";

  # dontNpmBuild = true;

  # postPatch = ''
  #   substituteInPlace package.json --replace '"version": "0.0.0"' '"version": "${version}"'
  # '';

  # nativeBuildInputs = [ pkg-config python3 ];

  # buildInputs = [ libsecret electron];

  makeCacheWritable = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];

  # npmBuild = ''
  #   npm run package:linux
  # '';

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = [ "--ignore-scripts" ];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  # ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
  # USE_SYSTEM_LIBDELTACHAT = "true";

  # dontNpmBuild = true;

  # installPhase = ''
  #     mkdir -p $out
  #     cp -r node_modules $out/
  #   '';


  meta = with lib; {
    description = "A cross platform desktop reading app, based on the Readium Desktop toolkit";
    homepage = "https://github.com/edrlab/thorium-reader";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
