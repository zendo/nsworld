{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gtk3,
  glib,
  libsecret,
  libayatana-appindicator,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "sshyard";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Licoy";
    repo = "sshyard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tIM1lBDdGh6r7XwA2PtiqjjSUAiDi2XIY59smwYzX6k=";
  };

  vendorHash = "sha256-CWtoEdL5+XKkDbW0DpGXDUHeCR2i6dt9BBVJjfnp36Q=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    go tool mygo build -platform linux/$GOARCH .
    runHook postBuild
  '';

  # Tests span the whole app, including macOS and Windows only paths
  doCheck = false;

  installPhase = ''
    runHook preInstall

    stage=build/linux-$GOARCH
    install -Dm755 "$stage/sshyard" $out/libexec/sshyard

    install -Dm644 "$stage/sshyard.png" $out/share/icons/hicolor/1024x1024/apps/sshyard.png
    install -Dm644 "$stage/sshyard.desktop" $out/share/applications/sshyard.desktop

    install -Dm644 LICENSE $out/share/licenses/sshyard/LICENSE
    install -Dm644 internal/icons/LICENSE $out/share/licenses/sshyard/icons-LICENSE
    install -Dm644 internal/aibrands/LICENSE $out/share/licenses/sshyard/aibrands-LICENSE

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/libexec/sshyard $out/bin/sshyard \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          libsecret
          libayatana-appindicator
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SSH, SFTP, serial and Telnet client with a native UI";
    homepage = "https://github.com/Licoy/sshyard";
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "sshyard";
    maintainers = with lib.maintainers; [ zendo ];
  };
})
