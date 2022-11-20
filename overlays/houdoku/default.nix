{ lib, fetchurl, appimageTools }:

let
  pname = "houdoku";
  version = "2.10.3";

  src = fetchurl {
    url = "https://github.com/xgi/houdoku/releases/download/v${version}/Houdoku-${version}.AppImage";
    hash = "sha256-RbMViFxLutvOq1dBiM5cekpTOHAiNwHJnBN2xDkN+kk=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A free and open source manga reader";
    homepage = "https://houdoku.org/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
