{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  autoPatchelfHook,
  copyDesktopItems,
  callPackage,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  gtk3,
  glib,
  gsettings-desktop-schemas,
  libdrm,
  libgbm,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  wayland,
  xorg,
  libGL,
  vulkan-loader,
  libva,
  libvdpau,
  gcc-unwrapped,
  patchelfUnstable,
}: let
  helium-widevine = callPackage ./widevine-x86_64-linux.nix {};
in
  stdenv.mkDerivation rec {
    pname = "helium";
    version = "0.7.5.1";

    src = fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
      hash = "sha256-VYwe1T5Ml0wjJf+vDKfAnZwZsieWywg5QJx1/kwW76E=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [
      autoPatchelfHook
      patchelfUnstable
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      gtk3
      glib
      gsettings-desktop-schemas
      libdrm
      libgbm
      libxkbcommon
      mesa
      nspr
      nss
      pango
      systemd
      wayland
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      gcc-unwrapped.lib
    ];

    runtimeDependencies = map lib.getLib [libGL mesa vulkan-loader libva libvdpau];

    appendRunpaths = [
      "${libGL}/lib"
      "${mesa}/lib"
      "${vulkan-loader}/lib"
      "${libva}/lib"
      "${libvdpau}/lib"
    ];

    patchelfFlags = ["--no-clobber-old-sections"];
    autoPatchelfIgnoreMissingDeps = [
      "libQt5Core.so.5"
      "libQt5Gui.so.5"
      "libQt5Widgets.so.5"
      "libQt6Core.so.6"
      "libQt6Gui.so.6"
      "libQt6Widgets.so.6"
    ];

    installPhase = ''
      mkdir -p $out/bin $out/opt/helium
      cp -r helium-${version}-x86_64_linux/* $out/opt/helium/
      chmod +x $out/opt/helium/{chrome,chrome-wrapper}

      cp -r ${helium-widevine}/share/helium/WidevineCdm $out/opt/helium/

      install -D $out/opt/helium/product_logo_256.png \
        $out/share/icons/hicolor/256x256/apps/helium.png

      install -Dm644 $out/opt/helium/helium.desktop \
      $out/share/applications/helium.desktop

      substituteInPlace $out/share/applications/helium.desktop \
        --replace-fail 'Exec=chromium' 'Exec=helium' \
        --replace-fail 'StartupWMClass=helium' 'StartupWMClass=Helium' \
        --replace-fail 'Icon=helium' 'Icon=helium'

      makeWrapper $out/opt/helium/chrome-wrapper $out/bin/helium \
        --chdir "$out/opt/helium" \
        --add-flags "--ozone-platform-hint=auto" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDependencies}"

      runHook postInstall
    '';

    meta = {
      description = "Private, fast, and honest web browser based on Chromium";
      homepage = "https://helium.computer";
      mainProgram = "helium";
      platforms = ["x86_64-linux"];
    };
  }
