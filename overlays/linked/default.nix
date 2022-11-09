{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "linked";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/lostdesign/linked/releases/download/v${version}/linked-${version}.AppImage";
    hash = "sha256-LuE9y+VCEnH/ndNBquJAfL2FQk12txeuqZTVNcVv99o=";
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
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
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
