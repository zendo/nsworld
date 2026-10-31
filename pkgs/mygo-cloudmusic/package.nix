{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  glib,
  gtk3,
  alsa-lib,
  libayatana-appindicator,
  makeWrapper,
  nix-update-script,
}:
# WIP!!!
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

  ldflags = [ "-s" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/netease-music-mygo \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          glib
          gtk3
          alsa-lib
          libayatana-appindicator
        ]
      }"
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MyGo 云音乐 - 第三方网易云音乐原生客户端";
    homepage = "https://github.com/egoist/mygo-cloudmusic";
    changelog = "https://github.com/egoist/mygo-cloudmusic/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mygo-cloudmusic";
  };
})
