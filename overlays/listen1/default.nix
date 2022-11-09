{ lib, fetchurl, appimageTools }:

let
  pname = "listen1";
  version = "2.26.2";

  src = fetchurl {
    url = "https://github.com/listen1/listen1_desktop/releases/download/v${version}/listen1_${version}_linux_x86_64.AppImage";
    hash = "sha256-C7zmBNL98s5NICH9H6+7rR+60vX6eNBcsaUK8I/wolc=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
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
    description = "A simple, clean and cross-platform music player";
    homepage = "https://github.com/listen1/listen1_desktop";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
