{ lib, fetchurl, appimageTools }:

let
  pname = "clashy";
  version = "0.2.7";

  src = fetchurl {
    url = "https://github.com/SpongeNobody/Clashy/releases/download/v${version}/Clashy-${version}.AppImage";
    hash = "sha256-Cm5MbARIBeDigeuqXlfBrL8pqauR+HGMdcDhtGe39Ck=";
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
    description = "A GUI proxy client based on Clash and Electron.";
    homepage = "https://github.com/SpongeNobody/Clashy";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
