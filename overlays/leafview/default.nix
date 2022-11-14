{ lib, fetchurl, appimageTools }:

let
  pname = "leafview";
  version = "2.2.12";

  src = fetchurl {
    url = "https://github.com/sprout2000/leafview/releases/download/v${version}/LeafView-${version}-linux-x86_64.AppImage";
    hash = "sha256-u1lbGu0haPIbBD+VPBMAdi1CYE36mvE1bAh8nW/RSxo=";
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
    description = "A minimalist image viewer based on Leaflet.js and Electron";
    homepage = "https://github.com/sprout2000/leafview";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nobody ];
  };
}
