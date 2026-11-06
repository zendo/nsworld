{
  lib,
  stdenv,
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
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "mygo-music";
  version = "0.1.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "egoist";
    repo = "mygo-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8eJw32TfmJ8nLhOW0cnrea9GirLyQrzRSNosyjrt4nY=";
  };

  vendorHash = "sha256-Cq2mujbu3e1eAXMr72SufOXpA6ShqqYQTiu5cBmpFRk=";

  nativeBuildInputs = [
    makeWrapper
    nodejs
  ];

  ldflags = [ "-s" ];

  buildPhase = ''
    runHook preBuild

    go tool mygo build

    runHook postBuild
  '';

  # The custom buildPhase above replaces buildGoModule's Go build hook,
  # so its getGoDirs-based checkPhase is not available here.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 build/linux-${go.GOARCH}/mygo-music \
      $out/bin/mygo-music

    install -Dm644 build/linux-${go.GOARCH}/mygo-music.png \
      $out/share/icons/hicolor/512x512/apps/mygo-music.png

    install -Dm644 build/linux-${go.GOARCH}/mygo-music.desktop \
      $out/share/applications/mygo-music.desktop

    runHook postInstall
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
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native music player you extend with plugins";
    homepage = "https://github.com/egoist/mygo-music";
    changelog = "https://github.com/egoist/mygo-music/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mygo-music";
  };
})
