{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  webkitgtk_4_1,
  glib-networking,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kiri";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "libracoder";
    repo = "kiri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6sEa+kgfJoZjUuAPWMZc1jbjXjw1B/aBRZkY+O1rgRo=";
  };

  cargoHash = "sha256-zYHkfntI7KAHUA3/11StA09IWJnsiA9axkwec51utss=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    glib-networking
  ];

  cargoBuildFlags = [
    "-p"
    "kiri"
    "-p"
    "kiri-init"
  ];
  # Upstream builds the static engine and a separate GTK window; in Nix the
  # engine is not static anyway, so one binary carries both.
  buildFeatures = [ "kiri/window" ];

  # Upstream's tests boot containers and a VM.
  doCheck = false;

  postInstall = ''
    install -Dm644 contrib/linux/kiri.desktop $out/share/applications/kiri.desktop
    substituteInPlace $out/share/applications/kiri.desktop \
      --replace-fail '/usr/lib/kiri/kiri-window ui' 'kiri ui' \
      --replace-fail '/usr/share/icons/hicolor/scalable/apps/kiri.svg' 'kiri'

    for size in 16 32 64 128 256 512; do
      install -Dm644 brand/icon/png/kiri-app-icon-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/kiri.png
    done
    install -Dm644 brand/icon/kiri-app-icon.svg \
      $out/share/icons/hicolor/scalable/apps/kiri.svg
  '';

  meta = {
    description = "Tiny, fast container runtime that speaks the Docker Engine API";
    homepage = "https://runkiri.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "kiri";
  };
})
