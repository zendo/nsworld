{ lib, fetchurl, appimageTools }:

let
  pname = "siyuan";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/siyuan-note/siyuan/releases/download/v2.5.0-dev2/siyuan-v202211121130-linux.AppImage";
    hash = "sha256-zSdsZfWy3jr/k1s4VmAcl/Pn96BdWZP+DUlWx/A+G2A=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
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
    description = "SiYuan is a local-first personal knowledge management system, supports fine-grained block-level reference, and Markdown WYSIWYG";
    homepage = "https://b3log.org/siyuan/";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
