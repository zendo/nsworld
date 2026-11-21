{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  mihomo,
  gtk3,
  glib,
  libayatana-appindicator,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bowel";
  version = "0.4.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "21stware";
    repo = "bowel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2e4QjIAcgyuZ7L1Fs5W3l0XG7benizQfR5LmiJWwcb0=";
  };

  vendorHash = "sha256-Ya2PWmFqEUArZ5HcydGajksLGCc0+HLhvljPwfNEnpk=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    go tool mygo build -platform linux/$GOARCH .
    runHook postBuild
  '';

  # Tests need a display and network access.
  doCheck = false;

  # Kept out of bin/: MyGo derives the window class and app id from its own
  # filename, which makeWrapper renames to .bowel-wrapped.
  installPhase = ''
    runHook preInstall

    stage=build/linux-$GOARCH
    install -Dm755 "$stage/bowel" $out/libexec/bowel

    install -Dm644 "$stage/bowel-256x256.png" $out/share/icons/hicolor/256x256/apps/bowel.png
    install -Dm644 "$stage/bowel-512x512.png" $out/share/icons/hicolor/512x512/apps/bowel.png
    install -Dm644 "$stage/bowel.desktop" $out/share/applications/bowel.desktop

    install -Dm644 LICENSE $out/share/licenses/bowel/LICENSE
    install -Dm644 PACKAGING-EXCEPTION.md $out/share/licenses/bowel/PACKAGING-EXCEPTION.md
    install -Dm644 assets/flags/LICENSE.md $out/share/licenses/bowel/flags-LICENSE.md

    runHook postInstall
  '';
  # cp -r "$stage/fonts" $out/libexec
  # install -Dm644 "$stage/fonts/OPPO Sans License.txt" $out/share/licenses/bowel/OPPO-Sans-License.txt

  # MOHO_CORE: the mihomo core bowel launches. APPIMAGE: a bare launcher name,
  # so the autostart entry does not pin this build's store path.
  postFixup = ''
    makeWrapper $out/libexec/bowel $out/bin/bowel \
      --set MOHO_CORE "${mihomo}/bin/mihomo" \
      --set APPIMAGE "bowel" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          gtk3
          glib
          libayatana-appindicator
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop client for mihomo";
    homepage = "https://github.com/21stware/bowel";
    changelog = "https://github.com/21stware/bowel/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [
      (lib.licenses.mkLicense {
        shortName = "polyformNoncommercial1_0_0";
        fullName = "PolyForm Noncommercial License 1.0.0 (with bowel Packaging Exception)";
        url = "https://polyformproject.org/licenses/noncommercial/1.0.0";
        free = false;
        redistributable = true;
      })
      lib.licenses.mit # Round country flag icons from circle-flags by HatScripts
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "bowel";
    maintainers = with lib.maintainers; [ zendo ];
  };
})
