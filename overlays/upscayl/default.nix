{ lib, fetchurl, appimageTools }:

let
  pname = "upscayl";
  version = "1.5.5";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/Upscayl-${version}.AppImage";
    hash = "sha256-OPaTalZbQAu2m6gli29TwvmZ1GxK1qtS+yeK8Fzs/Ck=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
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
    description = "Free and Open Source AI Image Upscaler";
    homepage = "https://github.com/upscayl/upscayl";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
