{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  pnpm,
  cargo,
  rustc,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libsoup,
  openssl,
  webkitgtk,
  libayatana-appindicator,
  mihomo,
  dbip-country-lite,
  v2ray-geoip,
  v2ray-domain-list-community,
}:

# https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/system/lact/default.nix
# https://github.com/clash-verge-rev/clash-verge-rev/blob/main/src-tauri/tauri.conf.json
# https://github.com/archlinuxcn/repo/blob/master/archlinuxcn/clash-verge/PKGBUILD
# https://github.com/clash-verge-rev/clash-verge-rev/blob/main/scripts/check.mjs#L54
stdenv.mkDerivation (finalAttrs: {
  pname = "clash-verge-rev";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "clash-verge-rev";
    repo = "clash-verge-rev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5sd0CkUCV52wrBPo0IRIa1uqf2QNkjXuZhE33cZW3SY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src-tauri";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # correct path for resources
    substituteInPlace $cargoDepsCopy/tauri-utils-*/src/platform.rs \
      --replace-fail "\"/usr" "\"$out"

    # skip build sidecar and resources
    sed -i -e '/externalBin/d' -e '/resources/d' tauri.conf.json
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-DYsx1X1yXYEPFuMlvZtbJdefcCR8/wSUidFwsMy8oLk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "sysproxy-0.3.0" = "sha256-TEC51s/viqXUoEH9rJev8LdC2uHqefInNcarxeogePk=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    nodejs
    pnpm.configHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libsoup
    openssl
    webkitgtk
    libayatana-appindicator
  ];

  preConfigure = ''
    chmod +w ..
  '';

  preBuild = ''
    cargo tauri build -b deb
  '';

  preInstall = ''
    mv target/release/bundle/deb/*/data/usr/ $out
  '';

  postFixup = ''
    ln -sf ${lib.getExe mihomo} $out/bin/clash-meta

    mkdir -p $out/lib/clash-verge/resources
    ln -sf ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources
    ln -sf ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources
    ln -sf ${dbip-country-lite.mmdb} $out/lib/clash-verge/resources/Country.mmdb
  '';

  meta = {
    description = "Clash Meta GUI based on Tauri, Continuation of Clash Verge";
    homepage = "https://github.com/clash-verge-rev/clash-verge-rev";
    mainProgram = "clash-verge";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
