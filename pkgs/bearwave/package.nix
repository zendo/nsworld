{
  lib,
  stdenv,
  cmake,
  ninja,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bearwave";
  version = "1.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "spalencsar";
    repo = "bearwave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PijU8UGsXJAiLb1Yx3TqDzi46df9bTUNV2rkyCaojcw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
    qt6.qttools # LinguistTools: qt_add_lrelease
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative # QtQuick, QtQuick.Controls (Fusion style too)
    qt6.qtmultimedia # the ffmpeg playback backend ships with it
    qt6.qtsvg # the station logos and app icon are SVG
    qt6.qtwayland # the Wayland platform plugin
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/de.nerdbear.bearwave.desktop \
      --replace-fail "${placeholder "out"}/bin/bearwave" "bearwave"
  '';

  # The tests write config and cache through QStandardPaths, which resolves to
  # /homeless-shelter with HOME unset, where nothing is writable.
  doCheck = true;
  preCheck = ''
    export HOME="$TMPDIR/home"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME"
  '';

  # Two of the test binaries wipe the same test-mode cache directory in their
  # initTestCase, so running them at the same time makes each delete the
  # other's fixtures.
  enableParallelChecking = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop internet radio player built with Qt 6 and QML";
    homepage = "https://github.com/spalencsar/bearwave";
    changelog = "https://github.com/spalencsar/bearwave/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "bearwave";
    platforms = lib.platforms.linux;
  };
})
