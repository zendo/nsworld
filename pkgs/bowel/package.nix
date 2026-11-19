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
  version = "0.4.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "21stware";
    repo = "bowel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5Ozk6b7D+wRIXgvljl0t2HyEFhUjZu5kijIlaSeyCw=";
  };

  vendorHash = "sha256-Ya2PWmFqEUArZ5HcydGajksLGCc0+HLhvljPwfNEnpk=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    go tool mygo build -platform linux/$GOARCH .
    runHook postBuild
  '';

  # The tests draw UI and open sockets; upstream runs none of them in CI.
  doCheck = false;

  # Not in bin/: MyGo names the window class, the Wayland app id and the
  # desktop entry after the basename of its own executable, and makeWrapper
  # renames whatever it wraps to .<name>-wrapped, which would leave GTK
  # announcing ".bowel-wrapped" to the dock: no StartupWMClass, no icon.
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

  # MyGo records os.Executable() in the autostart entry, which is a store path
  # without LD_LIBRARY_PATH or MOHO_CORE. $APPIMAGE is its hook for naming the
  # launcher instead: a bare command, so PATH finds the current build and the
  # entry outlives rebuilds.
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
