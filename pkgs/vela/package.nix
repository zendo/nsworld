{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  nix-update-script,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  libxkbcommon,
  pixman,
  libinput,
  libdrm,
  mesa,
  vulkan-headers,
  vulkan-loader,
  freetype,
  harfbuzz,
  fontconfig,
  librsvg,
  cairo,
  libxcb,
  systemd,
  pam,
  polkit,
  glib,
  pipewire,
  wireplumber,
  shaderc,
  python3,
  zlib,
  qt6,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vela";
  version = "0.1.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vela-desktop";
    repo = "vela";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N8dGa6ZVsJe90EsxbDlk4jvlOr9KnNq96lS0dRN8XIs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    shaderc
    wayland-scanner
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wlroots_0_20
    libxkbcommon
    pixman
    libinput
    libdrm
    mesa
    vulkan-headers
    vulkan-loader
    freetype
    harfbuzz
    fontconfig
    librsvg
    cairo
    libxcb
    systemd
    pam
    polkit
    glib
    pipewire
    wireplumber
    zlib
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    qt6.qtshadertools
    kdePackages.layer-shell-qt
  ];

  cmakeFlags = [
    "-DVELA_BUILD_TOOLS=OFF"
    "-DVELA_BUILD_CAPTURE_TOOLS=OFF"
    "-DVELA_BUILD_GPU_TEST_TOOLS=OFF"
  ];

  # The upstream CMake files install these two files to /etc; keep them inside
  # the store so the sandboxed build can install them.
  postPatch = ''
    substituteInPlace lock/CMakeLists.txt \
      --replace-fail 'DESTINATION /etc/pam.d' 'DESTINATION etc/pam.d'
    substituteInPlace session/CMakeLists.txt \
      --replace-fail 'DESTINATION /etc/xdg/xdg-desktop-portal-wlr' 'DESTINATION etc/xdg/xdg-desktop-portal-wlr'
  '';

  passthru = {
    providedSessions = [ "vela" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern, fluid and sharp Linux desktop built for today's hardware";
    homepage = "https://github.com/vela-desktop/vela";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "vela-session";
    platforms = lib.platforms.linux;
  };
})
