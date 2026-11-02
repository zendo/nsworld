{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  icoutils,
  gitMinimal,
  zenity,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitkwaken";
  version = "1.0.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maxpowerart";
    repo = "GitKwaken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F7KYcvc1O6WzGWYR0efJ3nDjQybK8JIt0hI0Jo0n8h4=";
  };

  cargoHash = "sha256-xTRp9IGqNuJWHjqJejSH42fICAyHZju6UMKHaOcSsB8=";

  cargoBuildFlags = [
    "--package"
    "gk-app"
  ];

  nativeBuildInputs = [
    makeWrapper
    icoutils
  ];

  postInstall = ''
    install -Dm644 packaging/linux/gitkwaken.desktop \
      $out/share/applications/gitkwaken.desktop

    # hicolor icons in the sizes contained in the Windows .ico
    mkdir -p icons
    icotool --extract --output=icons assets/icon.ico
    install -Dm644 icons/icon_1_16x16x32.png   $out/share/icons/hicolor/16x16/apps/gitkwaken.png
    install -Dm644 icons/icon_2_24x24x32.png   $out/share/icons/hicolor/24x24/apps/gitkwaken.png
    install -Dm644 icons/icon_3_32x32x32.png   $out/share/icons/hicolor/32x32/apps/gitkwaken.png
    install -Dm644 icons/icon_4_48x48x32.png   $out/share/icons/hicolor/48x48/apps/gitkwaken.png
    install -Dm644 icons/icon_5_64x64x32.png   $out/share/icons/hicolor/64x64/apps/gitkwaken.png
    install -Dm644 icons/icon_6_128x128x32.png $out/share/icons/hicolor/128x128/apps/gitkwaken.png
    install -Dm644 icons/icon_7_256x256x32.png $out/share/icons/hicolor/256x256/apps/gitkwaken.png
    install -Dm644 assets/icon-1024.png \
      $out/share/icons/hicolor/1024x1024/apps/gitkwaken.png

    # Legacy fallback used by some panel/taskbar implementations
    install -Dm644 assets/icon-256.png $out/share/pixmaps/gitkwaken.png

    wrapProgram $out/bin/gitkwaken \
      --prefix PATH : "${
        lib.makeBinPath [
          gitMinimal
          zenity
        ]
      }" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }"
  '';

  nativeCheckInputs = [ gitMinimal ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, lightweight, SourceTree-style git client";
    homepage = "https://github.com/maxpowerart/GitKwaken";
    changelog = "https://github.com/maxpowerart/GitKwaken/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "gitkwaken";
  };
})
