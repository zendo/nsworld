{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
  makeWrapper,
  mihomo,
  gtk3,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  libepoxy,
  libGL,
  fontconfig,
  harfbuzz,
  libsecret,
  libayatana-appindicator,
  libdbusmenu-gtk3,
  wayland,
  libx11,
  libxtst,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bowel";
  version = "0.4.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "21stware";
    repo = "bowel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cHujIsoQ+ooCMcooi4tTup3SZWAD09xR+vtPa9Rggp4=";
  };

  vendorHash = "sha256-R0dRempB8iU0z5HnDPZZYWOAmt0psFVU+YTtDYrJYdc=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    go tool mygo build -platform linux/${go.GOARCH} .
    runHook postBuild
  '';

  # The tests draw UI and open sockets; upstream runs none of them in CI.
  doCheck = false;

  installPhase = ''
    stage=build/linux-${go.GOARCH}

    # Not in bin/: MyGo names the window class, the Wayland app id and the
    # desktop entry after the basename of its own executable, and makeWrapper
    # renames whatever it wraps to .<name>-wrapped, which would leave GTK
    # announcing ".bowel-wrapped" to the dock: no StartupWMClass, no icon.
    install -Dm755 "$stage/bowel" $out/libexec/bowel

    # MyGo's resource directory on Linux is the executable's own directory, and
    # the bundled OPPO Sans face is the only resource read at run time.
    cp -r "$stage/fonts" $out/libexec

    install -Dm644 "$stage/bowel-256x256.png" $out/share/icons/hicolor/256x256/apps/bowel.png
    install -Dm644 "$stage/bowel-512x512.png" $out/share/icons/hicolor/512x512/apps/bowel.png
    install -Dm644 "$stage/bowel.desktop" $out/share/applications/bowel.desktop
  '';

  postFixup = ''
    # MyGo records os.Executable() in the autostart entry, which is a store
    # path without LD_LIBRARY_PATH or MOHO_CORE. $APPIMAGE is its hook for
    # naming the launcher instead: a bare command, so PATH finds the current
    # build and the entry outlives rebuilds.
    makeWrapper $out/libexec/bowel $out/bin/bowel \
      --set MOHO_CORE "${mihomo}/bin/mihomo" \
      --set APPIMAGE "bowel" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          gdk-pixbuf
          cairo
          pango
          atk
          libepoxy
          libGL
          fontconfig
          harfbuzz
          libsecret
          libayatana-appindicator # the tray icon
          libdbusmenu-gtk3 # its menu
          wayland
          libx11
          libxtst # global hotkeys
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for mihomo";
    homepage = "https://github.com/21stware/bowel";
    changelog = "https://github.com/21stware/bowel/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    # license = lib.licenses.mkLicense {
    #   shortName = "polyformNoncommercial1_0_0";
    #   fullName = "PolyForm Noncommercial License 1.0.0";
    #   url = "https://polyformproject.org/licenses/noncommercial/1.0.0";
    #   free = false; # noncommercial use only, so not an open source license
    # };
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "bowel";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
