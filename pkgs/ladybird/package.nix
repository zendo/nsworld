{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  libgcc,
  libdrm,
  libglvnd,
  libpulseaudio,
  libxcb,
  libxcb-wm,
  glib,
  qt6,
  vulkan-loader,
  wayland,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "2026.47.7";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://apt.ladybird.org/pool/main/l/ladybird/ladybird_${finalAttrs.version}-1~ubuntu26.04_amd64.deb";
    hash = "sha256-t8T4zl7SrkMN+1CmqMubBu86KQOY3irRGTlmkBZ6muI=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libgcc.lib
    libdrm
    libglvnd
    libpulseaudio
    libxcb
    libxcb-wm
    glib
    qt6.qtbase
    qt6.qtpositioning
  ];

  runtimeDependencies = [
    libglvnd
    vulkan-loader
    wayland
  ];

  # Referenced by name in the binary but only ever loaded when present
  # (GLESv1 for compositors that ask for it, Steam API for game overlays).
  autoPatchelfIgnoreMissingDeps = [
    "libGLES_CM.so.1"
    "libsteam_api.so"
  ];

  # The bundle resolves `libexec/`, `lib/` and `share/Lagom` relative to the
  # executable, so keep the same layout the .deb installs into /opt/ladybird.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    cp -a opt/ladybird $out/opt/
    chmod -R u+w $out/opt/ladybird

    mkdir -p $out/share
    cp -a usr/share/. $out/share/

    for prog in Ladybird WebDriver; do
      makeWrapper $out/opt/ladybird/bin/$prog $out/bin/$prog \
        --prefix QT_PLUGIN_PATH : ${qt6.qtbase}/lib/qt-6/plugins
    done
    ln -s Ladybird $out/bin/ladybird

    substituteInPlace \
      $out/share/applications/org.ladybird.Ladybird.desktop \
      $out/share/dbus-1/services/org.ladybird.Ladybird.service \
      --replace-fail /opt/ladybird/bin/Ladybird $out/bin/Ladybird

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    QT_QPA_PLATFORM=offscreen $out/bin/ladybird --version
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  # qtbase's setup hook cannot wrap our scripts, the wrappers are made by hand.
  dontWrapQtApps = true;

  meta = {
    description = "Truly independent web browser, using a novel engine based on web standards";
    homepage = "https://ladybird.org";
    downloadPage = "https://apt.ladybird.org/pool/main/l/ladybird/";
    license = lib.licenses.bsd2;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ladybird";
  };
})
