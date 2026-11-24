{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cacert,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pi-ui";
  version = "0.72.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hyperpuncher";
    repo = "pi-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QvMmnIwfly/UVEaiK7F+ehi8RaTRUQcyxk4iXJzFrKo=";
  };

  # bun2nix cannot read this project's lockfile (bun 1.4 writes lockfile v2),
  # so dependencies are resolved by bun itself in a fixed-output derivation.
  # Keeping that a plain FOD rather than a bun2nix-generated cache also keeps
  # `nix-update` usable: it prefetches the hash like any other dependency.
  bunDeps = stdenv.mkDerivation {
    pname = "pi-ui-bun-deps";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      cacert
    ];

    # The natives in node_modules ship prebuilt; patching them would only make
    # the output depend on the fixup of the day.
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      # --cpu=*/--os=* pull the optional bindings of every platform, which
      # keeps the hash stable across hosts.
      bun install --frozen-lockfile --no-progress --cpu="*" --os="*"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r node_modules $out
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-8JlnUIRAUZYa+GjASsnqr0j1sSIUvCUg8SsjgpnAUOM=";
  };

  nativeBuildInputs = [
    bun
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    # `bun build --compile` embeds the Bun runtime and fails without network,
    # so build the server bundle the npm release uses instead and run it with
    # nixpkgs' bun.
    cp -r ${finalAttrs.bunDeps} node_modules
    bun run assets:build
    bun scripts/build-npm.ts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pi-ui
    cp -r dist static package.json $out/share/pi-ui/

    makeWrapper ${lib.getExe bun} $out/bin/pi-ui \
      --chdir $out/share/pi-ui \
      --add-flags dist/npm/server-main.js

    runHook postInstall
  '';

  # nix-update only knows the npmDeps/pnpmDeps/... attribute names, so the
  # dependency FOD is also exposed as npmDeps: that is where `nix-update
  # --flake pi-ui` looks, and it rewrites the hash in bunDeps.
  passthru.npmDeps = finalAttrs.bunDeps;

  passthru.updateScript = nix-update-script {
    attrPath = "pi-ui";
    # The script runs nix-update on its own; without --flake it would look for
    # a default.nix in the repo root.
    extraArgs = [ "--flake" ];
  };

  meta = {
    description = "Keyboard-first minimal GUI for the pi coding agent";
    homepage = "https://pi-ui.app";
    downloadPage = "https://github.com/hyperpuncher/pi-ui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "pi-ui";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
