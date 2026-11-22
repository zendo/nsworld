{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  patchelf,
  bintools,

  # Linked dynamic libraries.
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gcc-unwrapped,
  gdk-pixbuf,
  glib,
  gtk3,
  gtk4,
  libcap,
  libdrm,
  libglvnd,
  libkrb5,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  vulkan-loader,
  wayland,

  # Loaded at runtime.
  libpulseaudio,
  libva,

  # Command line programs.
  coreutils,
  util-linux,
  xdg-utils,

  gsettings-desktop-schemas,
  adwaita-icon-theme,
  addDriverRunpath,
}:

let
  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gcc-unwrapped.lib
    gdk-pixbuf
    glib
    gtk3
    gtk4
    libcap
    libdrm
    libglvnd
    libkrb5
    libx11
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxkbcommon
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    libgbm
    libpulseaudio
    libva
    nspr
    nss
    pango
    pipewire
    systemdLibs
    vulkan-loader
    wayland
  ];

  rpath = lib.makeLibraryPath deps;
  binpath = lib.makeBinPath [
    coreutils
    util-linux
    xdg-utils
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ardia";
  # Upstream only ships Linux builds in the nightlies; the stable releases are
  # macOS/Windows only, so this tracks the newest nightly that has one.
  version = "0.2.47-nightly.9";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/ardia-browser/ardia/releases/download/v${finalAttrs.version}/Ardia-${finalAttrs.version}-linux-x64.tar.xz";
    hash = "sha256-CViJmvuUbEPwzrm2tN+BXSgFCusrKjRyxXsK39KeGf0=";
  };

  nativeBuildInputs = [
    makeWrapper
    patchelf
  ];

  buildInputs = [
    glib
    gtk3
    # XDG_ICON_DIRS / GSETTINGS_SCHEMAS_PATH for the wrapper.
    adwaita-icon-theme
    gsettings-desktop-schemas
  ];

  unpackPhase = ''
    runHook preUnpack
    tar -xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share
    cp -a ardia/lib/ardia $out/lib/ardia
    cp -a ardia/share/polkit-1 $out/share/polkit-1

    # The bundle carries its own loader; let the distro's ICDs be found instead.
    rm -f $out/lib/ardia/libvulkan.so.1
    ln -s ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 $out/lib/ardia/libvulkan.so.1

    for elf in $out/lib/ardia/chrome \
      $out/lib/ardia/chrome-sandbox \
      $out/lib/ardia/chrome_crashpad_handler \
      $out/lib/ardia/libEGL.so \
      $out/lib/ardia/libGLESv2.so \
      $out/lib/ardia/libvk_swiftshader.so; do
      patchelf --set-rpath ${rpath} $elf
      # chrome-sandbox is static and has no interpreter to point at.
      if patchelf --print-interpreter $elf >/dev/null 2>&1; then
        patchelf --set-interpreter ${bintools.dynamicLinker} $elf
      fi
    done

    # Nix cannot ship a setuid chrome-sandbox, and upstream's launcher refuses
    # to start otherwise. It accepts the user namespace sandbox as well, which
    # is what this falls back to; see the note in meta.notes below.
    chmod 0755 $out/lib/ardia/chrome-sandbox

    makeWrapper $out/lib/ardia/ardia-launch $out/bin/ardia \
      --prefix LD_LIBRARY_PATH : "${rpath}" \
      --prefix PATH : "${binpath}" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addDriverRunpath.driverLink}/share" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"

    install -Dm644 ardia/share/icons/hicolor/256x256/apps/ardia.png \
      $out/share/icons/hicolor/256x256/apps/ardia.png
    install -Dm644 ardia/share/applications/ardia.desktop \
      $out/share/applications/ardia.desktop
    substituteInPlace $out/share/applications/ardia.desktop \
      --replace-fail 'Exec=ardia ' "Exec=$out/bin/ardia "

    runHook postInstall
  '';

  meta = {
    description = "Chromium browser with Arc's sidebar and Dia's polish";
    homepage = "https://ardia.dev";
    changelog = "https://github.com/ardia-browser/ardia/releases";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ardia";
    notes = ''
      Upstream's launcher needs either the setuid chrome-sandbox (impossible in
      the Nix store) or unprivileged user namespaces. Keep
      user.max_user_namespaces above 0 and do not have AppArmor restrict
      unprivileged user namespaces, otherwise Ardia refuses to start.
    '';
  };
})
