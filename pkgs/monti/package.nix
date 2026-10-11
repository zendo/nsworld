{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook3,
  autoPatchelfHook,
  webkitgtk_4_1,
  glib-networking,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monti";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/stektus/monti/releases/download/v${finalAttrs.version}/Monti_${finalAttrs.version}_amd64.deb";
    hash = "sha256-fA6uv7KRq21jbpINIDtXQFWwPj0JQOGsImNh9HhvaB4=";
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
    description = "Friendly Linux GUI for rclone";
    homepage = "https://github.com/stektus/monti";
    changelog = "https://github.com/stektus/monti/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "monti";
  };
})
