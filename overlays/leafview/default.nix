{ lib, fetchurl, appimageTools }:

let
  pname = "leafview";
  version = "2.2.16";

  src = fetchurl {
    url = "https://github.com/sprout2000/leafview/releases/download/v${version}/LeafView-${version}-linux-x86_64.AppImage";
    hash = "sha256-kGnY0RoJ9l4l9KJYkSYbvQ2p2GjlX1LemqefCVfJMLo=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A minimalist image viewer based on Leaflet.js and Electron";
    homepage = "https://github.com/sprout2000/leafview";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nobody ];
  };
}
