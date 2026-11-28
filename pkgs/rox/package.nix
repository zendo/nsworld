{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  libgcc,
  alsa-lib,
  libxcb,
  libxkbcommon,
  libglvnd,
  vulkan-loader,
  wayland,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rox";
  version = "1.36.0";

  src = fetchurl {
    url = "https://github.com/zealsprince/rox/releases/download/v${finalAttrs.version}/rox_${finalAttrs.version}_amd64.deb";
    hash = "sha256-gIbJhQ/XBawtwBQ9NG8n9nPev/9sptVXob3PHY8KXjA=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libgcc.lib
    alsa-lib
    libxcb
    libxkbcommon
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
    wayland
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a usr/. $out/
  '';

  meta = {
    description = "If Foobar2000 was made in the current year";
    homepage = "https://rox.music";
    downloadPage = "https://github.com/zealsprince/rox";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "rox";
  };
})
