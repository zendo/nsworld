{
  lib,
  go,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  gtk3,
  glib,
  libsecret,
  libpulseaudio,
  libayatana-appindicator,
  webkitgtk_4_1,
  glib-networking,
  libsoup_3,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "mygo-music";
  version = "0.1.24";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "egoist";
    repo = "mygo-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RYaMXsrdVpjNogrJjgBh4llu1ldffRtzuly9s88CZ7A=";
  };

  vendorHash = "sha256-CgAnPtjfDxOxjVvIG8zvMXwbrqjhF3spEqXEagQSIvE=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  ldflags = [ "-s" ];

  buildPhase = ''
    go tool mygo build -platform "linux/${go.GOARCH}"
  '';

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  installPhase = ''
    stage=build/linux-${go.GOARCH}

    install -Dm755 "$stage/mygo-music" $out/libexec/mygo-music

    install -Dm644 "$stage/mygo-music-256x256.png" \
      $out/share/icons/hicolor/256x256/apps/mygo-music.png

    install -Dm644 "$stage/mygo-music-512x512.png" \
      $out/share/icons/hicolor/512x512/apps/mygo-music.png

    install -Dm644 "$stage/mygo-music.desktop" \
      $out/share/applications/mygo-music.desktop

    install -Dm644 LICENSE \
      $out/share/licenses/mygo-music/LICENSE
  '';

  postFixup = ''
    makeWrapper $out/libexec/mygo-music $out/bin/mygo-music \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          libsecret
          libpulseaudio
          libayatana-appindicator
          # Plugins' embedded login pages (host.webSignIn) need WebKitGTK and its TLS stack.
          webkitgtk_4_1
          glib-networking
          libsoup_3
        ]
      }" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native music player you extend with plugins";
    homepage = "https://github.com/egoist/mygo-music";
    changelog = "https://github.com/egoist/mygo-music/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mygo-music";
  };
})
