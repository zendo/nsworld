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
  version = "0.1.22";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "egoist";
    repo = "mygo-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cgp1qLckpUTOJfY9PZzhcHqknjqjPIbGDAuCj1M03sk=";
  };

  vendorHash = "sha256-SHmrMG6tYzGSBhvLMdIikLonjeR3r7IOeJiaGE+srik=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  ldflags = [ "-s" ];

  buildPhase = ''
    go tool mygo build -platform "linux/${go.GOARCH}"
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';

  installPhase = ''
    install -Dm755 build/linux-${go.GOARCH}/mygo-music \
      $out/bin/mygo-music

    install -Dm644 build/linux-${go.GOARCH}/mygo-music-256x256.png \
      $out/share/icons/hicolor/256x256/apps/mygo-music.png

    install -Dm644 build/linux-${go.GOARCH}/mygo-music-512x512.png \
      $out/share/icons/hicolor/512x512/apps/mygo-music.png

    install -Dm644 build/linux-${go.GOARCH}/mygo-music.desktop \
      $out/share/applications/mygo-music.desktop

    install -Dm644 LICENSE \
      $out/share/licenses/mygo-music/LICENSE
  '';

  postFixup = ''
    wrapProgram $out/bin/mygo-music \
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
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mygo-music";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
