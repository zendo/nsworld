{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  webkitgtk_4_1,
  glib-networking,
  nspr,
  nss,
  alsa-lib,
  libdrm,

  # enableEGL ? true,
  libglvnd,

  # enableVulkan ? true,
  vulkan-loader,

  # enableWayland ? true,
  wayland,
}:
let
  libs = [
    libglvnd
    vulkan-loader
    wayland
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "open-orpheus";
  version = "0.15.3";

  src = fetchurl {
    url = "https://github.com/YUCLing/open-orpheus/releases/download/v${finalAttrs.version}/open-orpheus_${finalAttrs.version}_amd64.deb";
    hash = "sha256-FSgtk32FqG7aFpFLTLmjhjX7uLs2nrNh04GKI3TPtsk=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    nspr
    nss
    alsa-lib
    libdrm
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [ (lib.getLib udev) ] ++ libs;

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  postFixup = ''
    wrapProgram $out/bin/open-orpheus \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
  '';

  meta = {
    description = "Open-source and cross-platform implementation of Netease Cloud Music's Orpheus browser host";
    homepage = "https://github.com/YUCLing/open-orpheus";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "open-orpheus";
  };
})
