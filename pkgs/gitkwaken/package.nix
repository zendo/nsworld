{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  wayland,
  zenity,
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

  nativeBuildInputs = [
    makeWrapper
  ];

  # installPhase = ''
  #   runHook preInstall
  #
  #   install -Dm755 bin/gitkwaken $out/bin/gitkwaken
  #
  #   install -Dm644 ${finalAttrs.src}/packaging/linux/gitkwaken.desktop \
  #     $out/share/applications/gitkwaken.desktop
  #
  #   install -Dm644 ${finalAttrs.src}/assets/logo.png \
  #     $out/share/pixmaps/gitkwaken.png
  #
  #   runHook postInstall
  # '';

  postInstall = ''
    wrapProgram $out/bin/gitkwaken \
      --prefix PATH ":" "${lib.makeBinPath [ zenity ]}" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxkbcommon
          vulkan-loader
          wayland
        ]
      }"
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "";
    homepage = "https://github.com/maxpowerart/GitKwaken";
    changelog = "https://github.com/maxpowerart/GitKwaken/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gitkwaken";
  };
})
