{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  kdePackages,
  openssl,
  fontconfig,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yunting";
  version = "0.6.40";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nephelesound";
    repo = "yunting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5IdQIozhubHiHvmAakzgodUPF7FtSZO6hyVmaec59DU=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  # libmpv 由 kdePackages.mpvqt 传递引入（mpv-unwrapped 的 libmpv），不要用 mpv：
  # 那是带 yt-dlp 脚本的播放器包装，会带进 deno、curl-impersonate 一整套。
  buildInputs = [
    openssl
    fontconfig
    zstd
  ]
  ++ (with kdePackages; [
    qtbase
    qtdeclarative
    qtwayland
    mpvqt
    qtkeychain
    prison
    kirigami
    kirigami-addons
    kcoreaddons
    kdbusaddons
    kwindowsystem
    kcolorscheme
    kconfig
    ki18n
    kstatusnotifieritem
    layer-shell-qt
  ]);

  # 上游测试连着真实接口和桌面会话，发行版打包一律关掉
  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  meta = {
    description = "Native KDE client for NetEase Cloud Music (Qt 6 / Kirigami)";
    homepage = "https://github.com/nephelesound/yunting";
    changelog = "https://github.com/nephelesound/yunting/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus # 程序本体
      mit # 应用图标（Microsoft Fluent Emoji）
      asl20 # src/third_party/material-color-utilities
    ];
    mainProgram = "yunting";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
