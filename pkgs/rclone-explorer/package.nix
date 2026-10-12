{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rclone-explorer";
  version = "5.3.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Jackpison";
    repo = "RcloneExplorer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m3vQua0NRQ0Q3mrsBR0wdLM5GKOfTjlkTkSXGQmOwY8=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  # git diff -- src/main_window.cpp > rclone-explorer-term.patch
  patches = [
    ./rclone-explorer-term.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/rclone-explorer \
      $out/bin/rclone-explorer

    install -Dm644 $src/packaging/linux/rclone-explorer.desktop \
      $out/share/applications/rclone-explorer.desktop

    install -Dm644 $src/packaging/linux/rclone-explorer.png \
      $out/share/icons/hicolor/512x512/apps/rclone-explorer.png

    install -Dm644 $src/packaging/linux/io.github.jackpison.RcloneExplorer.metainfo.xml \
      $out/share/metainfo/io.github.jackpison.RcloneExplorer.metainfo.xml

    runHook postInstall
  '';

  meta = {
    description = "Modern, portable rclone GUI";
    homepage = "https://github.com/Jackpison/RcloneExplorer";
    changelog = "https://github.com/Jackpison/RcloneExplorer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "rclone-explorer";
  };
})
