{ lib, fetchurl, appimageTools }:

let
  pname = "moosync";
  version = "6.0.0";

  src = fetchurl {
    url = "https://github.com/Moosync/Moosync/releases/download/v${version}/Moosync-${version}-linux-x86_64.AppImage";
    hash = "sha256-mnrAKqNgiDvaAvOvPILvbAue3olgNfLyyFZovUl7ou8=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A simple music player capable of playing local audio or from Youtube or Spotify";
    homepage = "https://moosync.app";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
