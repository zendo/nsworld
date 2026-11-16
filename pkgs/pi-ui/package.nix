{
  lib,
  stdenv,
  fetchFromGitHub,
  bun2nix,
  makeWrapper,
  bun,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pi-ui";
  version = "0.67.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "hyperpuncher";
    repo = "pi-ui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TDyQ0iJxEDqOI9fiQGiCttCATsaXp/ycCd3ieEwBCns=";
  };

  # bun.nix is bun.lock pruned to what the build imports; see its header.
  bunDeps = bun2nix.fetchBunDeps {
    bunNix = ./bun.nix;
  };

  nativeBuildInputs = [
    bun2nix.hook
    bun
    makeWrapper
  ];

  dontUseBunCheck = true;
  dontUseBunInstall = true;

  # The client bundles come from the same sources the server reads. The wasm
  # asset import needs the real package directory, which the isolated linker
  # replaces with a symlink bun's resolver will not follow.
  bunInstallFlags = [ "--linker=hoisted" ];

  buildPhase = ''
    runHook preBuild

    # `bun build --compile` embeds the Bun runtime and fails without network,
    # so build the server bundle the npm release uses instead and run it with
    # nixpkgs' bun.
    bun run assets:build
    bun scripts/build-npm.ts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pi-ui $out/bin
    cp -r dist static package.json $out/share/pi-ui/

    makeWrapper ${lib.getExe bun} $out/bin/pi-ui \
      --chdir $out/share/pi-ui \
      --add-flags dist/npm/server-main.js

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

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
