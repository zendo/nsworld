{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.AppImage";
    hash = "sha256-7Hci/cnmLsDUoAsQB4oRWb/IGNYINizmuq41l3DuNQM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/applications
    # cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/${pname}.desktop $out/share/applications/
    cp -a ${appimageContents}/usr/share/icons $out/share/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

    meta = with lib; {
    description = "A simple music player capable of playing local audio or from Youtube or Spotify";
    homepage = "https://moosync.app/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
