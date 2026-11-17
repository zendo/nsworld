{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  nodejs,
  webkitgtk_4_1,
  libsoup_3,
  libayatana-appindicator,
  gtk3,
  glib-networking,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prometheus";
  version = "0.30.25";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Mouseww/Prometheus/releases/download/v${finalAttrs.version}/Prometheus_${finalAttrs.version}_amd64.deb";
    hash = "sha256-wrcO7MdCjLAe716CL0ty/VuvLwWSvh6vuOxlY/dP5iQ=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    webkitgtk_4_1
    libsoup_3
    gtk3
  ];

  runtimeDependencies = [
    libayatana-appindicator
    glib-networking
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a usr/. $out/
    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set PROMETHEUS_NODE ${lib.getExe nodejs}
    )
  '';

  # Upstream's desktop entry has no Categories and points at the bare command
  # name. Its file name is also what GNOME and KDE match a Wayland window
  # against, and the window's app id is the binary name, so the file is renamed
  # to match it instead of keeping the capitalised Prometheus.desktop. The icon
  # name is already the one the deb installs.
  # postFixup = ''
  #   desktop=$out/share/applications/prometheus-desktop.desktop
  #   mv $out/share/applications/Prometheus.desktop $desktop
  #   substituteInPlace $desktop \
  #     --replace-fail "Exec=prometheus-desktop" "Exec=$out/bin/prometheus-desktop"
  # '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted AI agent workbench reached from terminal, browser and phone";
    homepage = "https://github.com/Mouseww/Prometheus";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "prometheus-desktop";
  };
})
