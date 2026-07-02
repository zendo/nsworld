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
  pname = "folia-major";
  version = "0.5.19";

  src = fetchurl {
    url = "https://github.com/chthollyphile/folia-major/releases/download/v${finalAttrs.version}/folia-major-${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-tNef9K7xPrKSlBcqoPaOmv8JhCfnvHhqoXWp/vG4fK8=";
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
    cp -r usr/* opt $out
    ln -s $out/opt/Folia/folia-major $out/bin
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail "/opt/Folia/folia-major" "${finalAttrs.pname}"
  '';

  postFixup = ''
    wrapProgram $out/bin/${finalAttrs.pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
  '';

  meta = {
    description = "Lyrics Reimagined Music Player";
    homepage = "https://github.com/chthollyphile/folia-major";
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "folia-major";
  };
})
