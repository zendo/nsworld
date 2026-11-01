{
  lib,
  stdenv,
  go,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  gtk3,
  glib,
  libsecret,
  libayatana-appindicator,
  libpulseaudio,
  nix-update-script,
}:
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=mygo-cloudmusic
buildGo127Module (finalAttrs: {
  pname = "mygo-cloudmusic";
  version = "0.1.22";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "egoist";
    repo = "mygo-cloudmusic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pr/rUFUiJiAYzIleKW5TIwlIiwjbRuveg/BFpYm6ZdI=";
  };

  vendorHash = "sha256-Rgn6r79jn4Am6fSEoX5xEzSmWViKJTQpYetKqDru0nI=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" ];

  buildPhase = ''
    runHook preBuild

    go tool mygo build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 build/linux-${go.GOARCH}/mygo-cloudmusic \
      $out/bin/mygo-cloudmusic

    install -Dm644 build/linux-${go.GOARCH}/mygo-cloudmusic.png \
      $out/share/icons/hicolor/512x512/apps/mygo-cloudmusic.png

    install -Dm644 build/linux-${go.GOARCH}/mygo-cloudmusic.desktop \
      $out/share/applications/mygo-cloudmusic.desktop

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/mygo-cloudmusic \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          libsecret
          libayatana-appindicator
          libpulseaudio
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MyGo 云音乐 - 第三方网易云音乐原生客户端";
    homepage = "https://github.com/egoist/mygo-cloudmusic";
    changelog = "https://github.com/egoist/mygo-cloudmusic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mygo-cloudmusic";
  };
})
