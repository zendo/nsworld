{ lib
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, electron
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

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-HAq68o0xkRE3a4sGxZOFblCm5Zs88N0OMIbYOqF4v/Y=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  distPhase = "true";

  buildPhase = ''
    runHook preBuild

    yarn --offline electron-builder \
      --dir --linux --x64 \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,nightpdf}
    cp deps/${pname}/dist/linux-unpacked/resources/app.asar $out/share/${pname}

    # pushd deps/nightpdf/build/icon.iconset
    # for image in *png; do
    #   mkdir -p $out/share/icons/hicolor/''${image%.png}/apps
    #   cp -r $image $out/share/icons/hicolor/''${image%.png}/apps/nightpdf.png
    # done
    # popd

    for size in 16 32 128 256 512; do
      install -D deps/nightpdf/build/icon.iconset/icon_''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    done

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "NightPDF";
      comment = meta.description;
      categories = [ "Office" ];
    })
  ];

  meta = with lib; {
    description = "Dark Mode PDF Reader built using Electron and PDF.js";
    homepage = "https://github.com/Lunarequest/NightPDF";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
