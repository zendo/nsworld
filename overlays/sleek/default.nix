{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "sleek";
  version = "1.2.9";

  src = fetchurl {
    url = "https://github.com/ransome1/${pname}/releases/download/v${version}/sleek-${version}.AppImage";
    hash = "sha256-WSCEvTjT0tFADJDkZQK/J4ZkhZT0vujVcvAVoaHVXDk=";
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
    description = "A modern ebook manager and reader";
    homepage = "https://github.com/ransome1/sleek";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
