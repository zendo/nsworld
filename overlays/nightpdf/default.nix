{ lib
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, electron
# , yarn
# , nodejs
, makeDesktopItem
, copyDesktopItems
, makeWrapper
}:

mkYarnPackage rec {
  pname = "nightpdf";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "Lunarequest";
    repo = "NightPDF";
    rev = "v${version}";
    hash = "sha256-QO9FRdd2TSqoIliCnouGg9CJT2/NIA7TjPx2fLMLJ9c=";
  };

  # packageJSON = ./package.json;
  # yarnLock = ./yarn.lock;
  # yarnNix = ./yarn.nix;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-HAq68o0xkRE3a4sGxZOFblCm5Zs88N0OMIbYOqF4v/Y=";
  };

  nativeBuildInputs = [
    # yarn
    # nodejs
    copyDesktopItems
    makeWrapper
  ];

  # buildInputs = [
  # ];

  # configurePhase = ''
  #   runHook preConfigure

  #   export HOME=$(mktemp -d)
  #   yarn config --offline set yarn-offline-mirror $offlineCache
  #   # fixup_yarn_lock yarn.lock
  #   yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
  #   patchShebangs node_modules/

  #   runHook postConfigure
  # '';


  buildPhase = ''
    runHook preBuild

    yarn --offline electron-builder \
      --dir --linux --x64 \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  distPhase = "true";
  # dontInstall = true;
  # dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,nightpdf}
    cp deps/nightpdf/dist/linux-unpacked/resources/app.asar $out/share/nightpdf

    # pushd deps/nightpdf/build/icon.iconset
    # for image in *png; do
    #   mkdir -p $out/share/icons/hicolor/''${image%.png}/apps
    #   cp -r $image $out/share/icons/hicolor/''${image%.png}/apps/nightpdf.png
    # done
    # popd

    mkdir -p $out/share/icons/hicolor/{32x32,128x128,256x256,512x512}/apps
    cp deps/nightpdf/build/icon.iconset/icon_32x32.png $out/share/icons/hicolor/32x32/apps/${pname}.png
    cp deps/nightpdf/build/icon.iconset/icon_128x128.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    cp deps/nightpdf/build/icon.iconset/icon_256x256.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    cp deps/nightpdf/build/icon.iconset/icon_512x512.png $out/share/icons/hicolor/512x512/apps/${pname}.png

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/nightpdf/app.asar

    runHook postInstall
  '';

  desktopItems = [(makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = pname;
    comment = meta.description;
    categories = [ "Office" ];
  })];

  meta = with lib; {
    description = "Dark Mode PDF Reader built using Electron and PDF.js";
    homepage = "https://github.com/Lunarequest/NightPDF";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
