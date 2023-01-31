{ lib, fetchurl, appimageTools }:

let
  pname = "yesplaymusic";
  version = "0.4.7";

  src = fetchurl {
    url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-${version}.AppImage";
    hash = "sha256-y0h2u/k4UCrKyE/2j+vIY+K835peSkuWThcwm37jcE4=";
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
    description = "A third party electron-based Netease Cloud Music";
    homepage = "https://github.com/qier222/YesPlayMusic";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
