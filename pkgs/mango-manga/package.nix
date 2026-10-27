{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  gtk3,
  webkitgtk_4_1,
  glib-networking,
  libayatana-appindicator,
  jdk_headless,
  udev,
  multiverse,
  xdotool,
}:
let
  # libxdo.so.3
  xdotool = multiverse.versions.xdotool."3.20211022.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mango-manga";
  version = "1.3.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/apixelsnet/mango/releases/download/v${finalAttrs.version}/mango-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-JW6IRqy5x3KdwZNMySLVsolkFYWWg7A4mLCtibLQlqY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    glib-networking
    libayatana-appindicator
    xdotool
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,mango}
    cp -r . $out/mango

    makeWrapper $out/mango/mango $out/bin/mango \
      --prefix PATH : ${lib.makeBinPath [ jdk_headless ]}

    makeWrapper $out/mango/mango-desktop $out/bin/mango-desktop \
      --prefix PATH : ${lib.makeBinPath [ jdk_headless ]}

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted manga and manhwa reader that runs Mihon extensions";
    homepage = "https://github.com/apixelsnet/mango";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "mango";
  };
})
