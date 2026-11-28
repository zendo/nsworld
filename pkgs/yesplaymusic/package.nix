{
  lib,
  fetchFromGitHub,
  flutter350,
  mpv-unwrapped,
  libsecret,
  libpulseaudio,
  nix-update-script,
}:

flutter350.buildFlutterApplication (finalAttrs: {
  pname = "yesplaymusic";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "qier222";
    repo = "YesPlayMusic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wEBfp+wU/vCMy9h1bG8k3GzL4EWZdIFVUrsikyPUIAI=";
  };

  # Generated from the repo's pubspec.lock with `yq -o=json pubspec.lock`.
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # Playback goes through media_kit, which dlopen()s libmpv; libsecret and
  # libpulseaudio back the app's optional system integrations.
  buildInputs = [
    mpv-unwrapped
    libsecret
    libpulseaudio
  ];

  postInstall = ''
    install -Dm644 linux/packaging/yesplaymusic.desktop \
      $out/share/applications/yesplaymusic.desktop
    install -Dm644 linux/packaging/yesplaymusic.png \
      $out/share/icons/hicolor/512x512/apps/yesplaymusic.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop music player with a plugin system";
    homepage = "https://github.com/qier222/YesPlayMusic";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yesplaymusic";
    platforms = lib.platforms.linux;
  };
})
