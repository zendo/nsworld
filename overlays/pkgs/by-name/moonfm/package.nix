{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "moonfm";
  version = "4.0.25";

  src = fetchurl {
    url = "https://moon.fm/dist/MoonFM-${version}-x86_64.AppImage";
    hash = "sha256-clQzfrfJRHwt5yb9x2reBHGVWkbyMzH0e5BipfbzDlA=";
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
    description = "A modern, fully featured audio podcast player in a simple, intuitive interface";
    homepage = "https://moon.fm";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
