{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  glib-networking,
  libayatana-appindicator,
  libglvnd,
  vulkan-loader,
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
  pname = "geetree";
  version = "0.6.1";

  src = fetchurl {
    url = "https://github.com/cmzy/geetree/releases/download/v${finalAttrs.version}/GeeTree_amd64.deb";
    hash = "sha256-+HJlBDJ6bWyRYoGBmptGvBz5hXHaPb2nyFppR/fOXmQ=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    # glib-networking
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ]
  ++ libs;

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Professional Git client, rendered on the GPU";
    homepage = "https://geetree.app/";
    downloadPage = "https://github.com/cmzy/geetree";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "geetree";
  };
})
