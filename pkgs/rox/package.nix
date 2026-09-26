{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  alsa-lib,
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
  pname = "rox";
  version = "1.28.6";

  src = fetchurl {
    url = "https://github.com/zealsprince/rox/releases/download/v${finalAttrs.version}/rox_${finalAttrs.version}_amd64.deb";
    hash = "sha256-hJXvqlLUrtN2qhjmPb/TlswklYOOFYNk1V2PcGpfnJ0=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    glib-networking
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
    description = "If Foobar2000 was made in the current year";
    homepage = "https://rox.music";
    downloadPage = "https://github.com/zealsprince/rox";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "zenus";
  };
})
