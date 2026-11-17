{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  kdePackages,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krema";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "krema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lI2XrRxjiSYr1UNgO+tZZSu+wLFPTVapTM8cAvm59V8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtshadertools
    kdePackages.qtwayland

    kdePackages.kwindowsystem
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdbusaddons
    kdePackages.ki18n
    kdePackages.kglobalaccel
    kdePackages.kcolorscheme
    kdePackages.kiconthemes
    kdePackages.kcrash
    kdePackages.kxmlgui
    kdePackages.kservice
    kdePackages.kio
    kdePackages.kjobwidgets
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.layer-shell-qt
    kdePackages.kpipewire

    wayland
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "KREMA_E2E_TESTS" false)
  ];

  meta = {
    description = "Lightweight, high-performance dock for KDE Plasma 6";
    homepage = "https://github.com/isac322/krema";
    changelog = "https://github.com/isac322/krema/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      mit-cmu
    ];
    platforms = lib.platforms.linux;
    mainProgram = "krema";
  };
})
