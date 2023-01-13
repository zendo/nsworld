{ lib, fetchurl, appimageTools }:
let
  pname = "listen1";
  version = "2.27.0";

  src = fetchurl {
    url = "https://github.com/listen1/listen1_desktop/releases/download/v${version}/listen1_${version}_linux_x86_64.AppImage";
    hash = "sha256-tVtaTWn7dF+Swxo2c18Fw0/ne5EF02tJE+JBD+yOK2M=";
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
    description = "A simple, clean and cross-platform music player";
    homepage = "https://github.com/listen1/listen1_desktop";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
