{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libgcc,
  libglvnd,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "geetree";
  version = "0.6.2";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/cmzy/geetree/releases/download/v${finalAttrs.version}/GeeTree_amd64.deb";
    hash = "sha256-YAzJefqjQO1BHXb0FIa6SzLCqcDWcyFltKy7S6aU60A=";
  };

  sourceRoot = "root";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc.lib
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
    cp -a usr/. $out/
    runHook postInstall
  '';

  stripAllList = [ "bin" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Professional Git client, rendered on the GPU";
    homepage = "https://geetree.app";
    downloadPage = "https://github.com/cmzy/geetree";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "geetree";
  };
})
