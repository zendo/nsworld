{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kde-backup";
  version = "0.1.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pakru";
    repo = "kde_backup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tncd5UPC53auDCZn1C/FZ5BUxhNk/0bbc4hc70Hb0UQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  buildInputs = with kdePackages; [
    qtbase
    qtdeclarative
    karchive
    kconfig
    kcoreaddons
    ki18n
    kio
    kirigami
    knotifications
  ];

  # 上游 CMakeLists 已按 KDEInstallDirs 装好 desktop 文件与 appdata，不必再补。

  # ctest 里的集成测试要一个可写的 HOME；QML 引擎那组要离屏平台。
  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_QPA_PLATFORM=offscreen
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Back up and restore KDE Plasma 6 user settings";
    homepage = "https://github.com/pakru/kde_backup";
    changelog = "https://github.com/pakru/kde_backup/blob/${finalAttrs.src.tag}/README.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
    mainProgram = "kde-backup";
  };
})
