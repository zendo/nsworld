# WowType：fcitx5 插件 + 设置界面 + 自检工具 + 词库。
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cargo,
  rustc,
  cmake,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  fcitx5,
  alsa-lib,
  gtk4,
  libadwaita,
  python3,
  enableSettings ? true,
}:

let
  version = "0.5.1";
  dataVersion = "2026.11.11.7";

  data = fetchurl {
    url = "https://github.com/Gloridust/WowType/releases/download/v${version}/wowtype-data-rime-ice-${dataVersion}.tar.gz";
    hash = "sha256-s1pK92Vz67HHtALFKF0zu7HOKzJEdwvvnpCCbD/PyKo=";
  };

  pythonEnv = python3.withPackages (ps: [ ps.pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wowtype";
  inherit version;
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gloridust";
    repo = "WowType";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J0/zu43MA/TOunMfgLM1kavP2xTAuEJR0i16EWj4rH8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-IPoQFvULOjT7Y9waZy7sdexGp9/Z4qVBw5I4rAJDu3M=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cmake
    pkg-config
  ]
  ++ lib.optionals enableSettings [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    fcitx5
    alsa-lib
  ]
  ++ lib.optionals enableSettings [
    gtk4
    libadwaita
    pythonEnv
  ];

  # 自检工具默认去 /usr/share/wowtype 找词库，改成本包的目录
  postPatch = ''
    substituteInPlace core/src/bin/check.rs \
      --replace-fail /usr/share/wowtype "$out/share/wowtype"
  '';

  # 插件静态链接 Rust 核心：CMake 配置时 target/release/libwowtype_core.a 必须已经在
  preConfigure = ''
    cargo build --release --frozen --offline -p wowtype-core \
      --lib --bin wowtype-check --bin wowtype-show
  '';

  cmakeDir = "../fcitx5-addon";
  cmakeFlags = [
    (lib.cmakeFeature "WOWTYPE_VERSION" finalAttrs.version)
    (lib.cmakeBool "WOWTYPE_INSTALL_SETTINGS" enableSettings)
    # 词库不从源码树装（tag 里也没有 dist/data），全部由上面钉的压缩包提供
    (lib.cmakeFeature "WOWTYPE_DATA_DIR" "")
    (lib.cmakeFeature "FCITX_INSTALL_PKGDATADIR" "${placeholder "out"}/share/fcitx5")
  ];

  postInstall = ''
    rm -rf "$out/include"

    mkdir -p data
    tar -xzf ${data} -C data
    install -Dm644 -t "$out/share/wowtype" data/lexicon.tsv data/english.txt data/words.lm
    install -Dm644 -t "$out/share/wowtype" data/DATA-MANIFEST
    install -Dm644 -t "$out/share/wowtype" data/nnlm.bin

    install -Dm644 ../README.md "$out/share/doc/wowtype/README.md"
    install -Dm644 data/SOURCE.txt "$out/share/doc/wowtype/DATA-SOURCE.txt"
    echo ${dataVersion} > "$out/share/doc/wowtype/DATA-VERSION"
    install -Dm644 data/LICENSE "$out/share/licenses/wowtype/LICENSE.rime-ice"

    install -Dm644 -t "$out/share/wowtype" data/wubi86.tsv
    install -Dm644 -t "$out/share/doc/wowtype" data/WUBI-SOURCE.txt data/WUBI-AUTHORS
    install -Dm644 data/WUBI-LICENSE "$out/share/licenses/wowtype/LICENSE.rime-wubi"

    if [ -e "$out/bin/wowtype-config" ]; then
      substituteInPlace "$out/bin/wowtype-config" \
        --replace-fail '#!/usr/bin/python3' '#!${pythonEnv.interpreter}' \
        --replace-fail /usr/share/wowtype "$out/share/wowtype" \
        --replace-fail /usr/share/doc/wowtype "$out/share/doc/wowtype"
    fi
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$(mktemp -d)
    test -f $out/lib/fcitx5/libwowtype.so
    test -f $out/share/fcitx5/addon/wowtype.conf
    test -f $out/share/fcitx5/inputmethod/wowtype.conf
    test -s $out/share/wowtype/words.lm
    $out/bin/wowtype-check
    $out/bin/wowtype-show --lexicon $out/share/wowtype/lexicon.tsv nihao | grep -q '1\.你好'
    if [ -x $out/bin/wowtype-config ]; then
      $out/bin/wowtype-config --self-test
    fi

    # DATA-MANIFEST 里列出的数据文件都得真的装上：钉的词库包和这条检查最容易脱节
    if [ -f $out/share/wowtype/DATA-MANIFEST ]; then
      awk -F'\t' '!/^#/ && NF { print $1 }' $out/share/wowtype/DATA-MANIFEST | while read -r name; do
        test -f "$out/share/wowtype/$name"
      done
    fi

    # 自检会把词库快照写到词库旁边（构建时 $out 可写），装出来的包里不该带这个缓存
    find $out -name '*.wcache' -delete

    runHook postInstallCheck
  '';

  meta = {
    description = "WeChat-style pinyin input method for fcitx5, with bundled dictionaries and language model";
    homepage = "https://github.com/Gloridust/WowType";
    mainProgram = "wowtype-config";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      mit
      asl20
      unicode-30
      gpl3Only # 词库（rime-ice）
      cc-by-sa-40 # 词级语言模型 words.lm、整句增强模型 nnlm.bin
      lgpl3Only # 五笔码表 wubi86.tsv（rime-wubi）
    ];
  };
})
