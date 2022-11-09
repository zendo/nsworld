{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, appimage-run
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "motrix";
  version = "1.6.11";

  src = fetchurl {
    url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}.AppImage";
    hash = "sha256-tE2Q7NM+cQOg+vyqyfRwg05EOMQWhhggTA6S+VT+SkM=";
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
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/${pname}.desktop $out/share/applications/
    cp -a ${appimageContents}/usr/share/icons $out/share/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron "$out/bin/${pname}" \
      --add-flags "$out/share/${pname}/app.asar" \
      --set ELECTRON_IS_DEV 0 \
      --set NODE_ENV production
  '';

    meta = with lib; {
    description = "A full-featured download manager";
    homepage = "https://motrix.app";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
