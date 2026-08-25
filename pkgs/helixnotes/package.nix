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
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "helixnotes";
  version = "1.3.4";

  src = fetchurl {
    url = "https://download.helixnotes.com/releases/v${finalAttrs.version}/HelixNotes_${finalAttrs.version}_amd64.deb";
    hash = "sha256-IiIKelur40N7EGINP+6XuVUbdKf2RCz+fALg+ixmiq0=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook3
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    glib-networking
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr/* $out
  '';

  meta = {
    description = "Local Markdown note-taking app. No cloud, no account, no telemetry";
    homepage = "https://helixnotes.com";
    downloadPage = "https://gitlab.com/ArkHost/HelixNotes";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "helixnotes";
  };
})
