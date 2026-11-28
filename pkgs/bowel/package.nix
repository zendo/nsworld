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
  version = "0.4.10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "21stware";
    repo = "bowel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+M0CqvreVCNZrmlwOD+YLYAl03UsCkYQNTjKR7HNALQ=";
  };

  vendorHash = "sha256-VyppSQJJnwhmo5bAUHBudchucBR+if4wJp9uhXThmhQ=";

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    runHook preBuild
    go tool mygo build -platform linux/$GOARCH .
    runHook postBuild
  '';

  # Tests need a display and network access
  doCheck = false;

  # Kept out of bin/, MyGo uses its executable name as window class
  # and app id, which makeWrapper would change to .bowel-wrapped
  installPhase = ''
    runHook preInstall

    stage=build/linux-$GOARCH
    install -Dm755 "$stage/bowel" $out/libexec/bowel
    cp -r "$stage/fonts" $out/libexec/fonts

    install -Dm644 "$stage/bowel-256x256.png" $out/share/icons/hicolor/256x256/apps/bowel.png
    install -Dm644 "$stage/bowel-512x512.png" $out/share/icons/hicolor/512x512/apps/bowel.png
    install -Dm644 "$stage/bowel.desktop" $out/share/applications/bowel.desktop

    install -Dm644 LICENSE PACKAGING-EXCEPTION.md -t $out/share/licenses/bowel
    install -Dm644 "$stage/fonts/"*License.txt -t $out/share/licenses/bowel
    install -Dm644 assets/flags/LICENSE.md $out/share/licenses/bowel/flags-LICENSE.md

    runHook postInstall
  '';

  # MOHO_CORE: use system mihomo instead of the bundled core
  # APPIMAGE: keep the autostart entry a bare command, not a /nix/store path
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
      lib.licenses.ofl # the bundled fonts: Raise Sans, Jost, IBM Plex Mono
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "bowel";
    maintainers = with lib.maintainers; [ zendo ];
  };
})
