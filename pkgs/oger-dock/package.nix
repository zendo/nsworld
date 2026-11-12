{
  lib,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitHub,
  kdePackages,
  pipewire,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oger-dock";
  version = "1.0.0";
  __structuredAttrs = true;

  # The repository has no version tag: "lançamento" is the empty first commit,
  # and 1.0.0 is what the tree has been since the release commit.
  src = fetchFromGitHub {
    owner = "dsrsouza";
    repo = "Oger-Dock";
    rev = "ff5cb2c05146b24013ba526649970eed66097c6c";
    hash = "sha256-di+4LvEwb8L47wU/BDNqNEFQ/p2byHMDn3ajOxQjZBY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gettext # msgfmt, for the po/ catalogs
    kdePackages.extra-cmake-modules
    kdePackages.qtshadertools # qsb, which bakes the two shaders
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kglobalaccel
    kdePackages.ki18n
    kdePackages.kjobwidgets
    kdePackages.kio
    kdePackages.kpackage
    kdePackages.kwindowsystem
    kdePackages.libplasma
    kdePackages.plasma-activities
    kdePackages.plasma-activities-stats
    kdePackages.plasma-workspace # LibKWorkspace: PW::KWorkspace
    pipewire # the audio spectrum
  ];

  # A plasmoid: no executable of its own to wrap, and the QML module it loads
  # is found inside its package.
  dontWrapQtApps = true;

  cmakeFlags = [
    # Keep the native QML module inside the applet's own package: Plasma adds
    # the package's contents/ui to the import path, while a module in
    # $out/lib/qt-6/qml would be found by no one that is not wrapped for it.
    "-DPUNCHI_EMBED_QML_MODULE_IN_KPACKAGE=ON"
    "-DBUILD_TESTING=OFF" # the developer suite is Node and lives in tests-dev
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "skip"
    ];
  };

  meta = {
    description = "Customizable launcher dock for KDE Plasma 6";
    homepage = "https://github.com/dsrsouza/Oger-Dock";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    platforms = lib.platforms.linux;
  };
})
