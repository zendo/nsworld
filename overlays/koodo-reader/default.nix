{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
, electron
, makeWrapper
}:

mkYarnPackage rec {
  pname = "koodo-reader";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5H43kLxtjUvn4vwhdy3oCA8Iw+yQ+KBocQLemXiVhUA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-Qrn99eOKndbg+8zH5YEog0DwL5Jh18hCCEzVCg1uHu8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  distPhase = "true";

  buildPhase = ''
    runHook preBuild

    yarn --offline electron-builder \
      --dir --linux --x64 \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postbuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,koodo-reader}
    cp deps/${pname}/dist/linux-unpacked/resources/app.asar $out/share/${pname}
    cp -r ./* $out/share/koodo-reader

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "All-in-one ebook reader";
    homepage = "https://koodo.960960.xyz/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
