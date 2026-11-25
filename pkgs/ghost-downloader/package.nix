{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dbus,
  copyDesktopItems,
  libglvnd,
  fontconfig,
  freetype,
  glib,
  libkrb5,
  wayland,
  libx11,
  libxcb,
  libxkbcommon,
  xcbutil,
  xcbutilcursor,
  xcbutilimage,
  xcbutilkeysyms,
  xcbutilrenderutil,
  xcbutilwm,
  zlib,
  zstd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ghost-downloader";
  version = "4.6";
  __structuredAttrs = true;

  # Upstream only publishes this Nuitka bundle for Linux; it carries its own
  # Python 3.13, Qt 6.10 and PySide6.
  src = fetchurl {
    name = "Ghost-Downloader-v${finalAttrs.version}-Linux-x86_64.tar.xz";
    url = "https://github.com/XiaoYouChR/Ghost-Downloader-3/releases/download/v${finalAttrs.version}/Ghost-Downloader-v${finalAttrs.version}-Linux-x86_64.tar.xz";
    hash = "sha256-cYlcruHkYngNlhAdUsaCQjjmUz6RRLaTXEtg8by1dlU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    dbus
    fontconfig
    freetype
    glib
    libglvnd
    libkrb5
    libx11
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
    wayland
    xcbutil
    xcbutilcursor
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
    zlib
    zstd
  ];

  # Only the third-party dependencies are missing; the bundle ships everything
  # the Python side imports at run time.
  #
  # Unpack into a subdirectory: stdenv writes its own bookkeeping (.attrs.json,
  # env-vars) into the build root, and copying that into $out would drag the
  # whole build closure along as runtime references.
  unpackPhase = ''
    mkdir -p source
    tar xf $src -C source
  '';
  sourceRoot = "source";

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # The program locates its feature packs, assets and updater beside itself,
    # so the bundle has to stay in one directory.
    bundle=$out/lib/ghost-downloader-3
    install -d "$bundle" $out/bin
    cp -a . "$bundle"

    # Drop the Qt plugins that only matter for embedded, printing and VNC use
    # but drag in KMS, GTK, CUPS and TIFF stacks.
    rm -rf "$bundle"/PySide6/qt-plugins/egldeviceintegrations \
      "$bundle"/PySide6/qt-plugins/printsupport
    rm -f "$bundle"/PySide6/qt-plugins/platforms/libqeglfs.so \
      "$bundle"/PySide6/qt-plugins/platforms/libqlinuxfb.so \
      "$bundle"/PySide6/qt-plugins/platforms/libqminimalegl.so \
      "$bundle"/PySide6/qt-plugins/platforms/libqvkkhrdisplay.so \
      "$bundle"/PySide6/qt-plugins/platforms/libqvnc.so \
      "$bundle"/PySide6/qt-plugins/imageformats/libqtiff.so \
      "$bundle"/PySide6/qt-plugins/platformthemes/libqgtk3.so

    # Their only consumers were the plugins above.
    rm -f "$bundle"/libQt6EglFsKmsSupport.so.6 \
      "$bundle"/libQt6EglFSDeviceIntegration.so.6 \
      "$bundle"/libQt6VirtualKeyboardQml.so.6

    ln -s "$bundle/Ghost-Downloader-3.bin" $out/bin/ghost-downloader
    ln -s "$bundle/Ghost-Downloader-3.bin" $out/bin/ghd

    install -Dm644 logo.png \
      $out/share/icons/hicolor/256x256/apps/ghost-downloader.png

    runHook postInstall
  '';

  desktopItems = [
    (builtins.toFile "com.xychr.ghostdownloader.desktop" ''
      [Desktop Entry]
      Type=Application
      Name=Ghost Downloader
      Comment=The only downloader you need
      Exec=ghost-downloader %U
      Icon=ghost-downloader
      Terminal=false
      Categories=Network;Utility;
      StartupWMClass=com.xychr.ghostdownloader
    '')
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multithreaded downloader with browser integration, Bilibili, m3u8 and BitTorrent support";
    homepage = "https://github.com/XiaoYouChR/Ghost-Downloader-3";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ghost-downloader";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
})
