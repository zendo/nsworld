{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libglvnd,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geetree";
  version = "0.6.2";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/cmzy/geetree/releases/download/v${finalAttrs.version}/GeeTree_amd64.deb";
    hash = "sha256-YAzJefqjQO1BHXb0FIa6SzLCqcDWcyFltKy7S6aU60A=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libxcb
    libxkbcommon
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
    wayland
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a usr/. $out/
    runHook postInstall
  '';

  # The default `strip -S` only drops debug info, and the release binary has
  # none: it still carries a 105 MB .symtab. `stripAllList` switches to
  # `strip -s`, which reclaims that.
  stripAllList = [ "bin" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Professional Git client, rendered on the GPU";
    homepage = "https://geetree.app";
    downloadPage = "https://github.com/cmzy/geetree";
    license = lib.licenses.mit; # fake licenses
    # license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "geetree";
  };
})
