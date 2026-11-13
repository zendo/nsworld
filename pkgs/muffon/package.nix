{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  udev,
  nspr,
  nss,
  libgbm,
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
  pname = "muffon";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/staniel359/muffon/releases/download/v${finalAttrs.version}/muffon-${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-NuezfNRwHBvpWw0HpXks3x5SzXNCACpqU8HFxNEjgro=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    nspr
    nss
    libgbm
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
    cp -r opt usr/* $out
    ln -s $out/opt/muffon/muffon $out/bin/muffon
    substituteInPlace $out/share/applications/com.electron.muffon.desktop \
      --replace-fail "/opt/muffon/muffon" "muffon"
  '';

  meta = {
    description = "Advanced multi-source music streaming + discovery client for desktop";
    homepage = "https://muffon.netlify.app/";
    downloadPage = "https://github.com/staniel359/muffon";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "muffon";
  };
})
