{ lib, fetchurl, appimageTools }:
let
  pname = "nightpdf";
  version = "0.4.4";

  src = fetchurl {
    url = "https://github.com/Lunarequest/NightPDF/releases/download/v${version}/NightPDF-${version}.AppImage";
    hash = "sha256-7iy+vEcqPL+YlIToViqcEbrKGoqZaSLDZMEBHWzJZWA=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Dark Mode PDF Reader built using Electron and PDF.js";
    homepage = "https://github.com/Lunarequest/NightPDF";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
