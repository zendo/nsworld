{ lib, fetchurl, appimageTools }:

let
  pname = "thorium-reader";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/edrlab/thorium-reader/releases/download/latest-linux/Thorium-${version}-alpha.0.3537141800.AppImage";
    hash = "sha256-rGt2Ofs9h5SO+5gAqI4BlS2Vn0MAinZlNTI+Pv2Z8q0=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/thorium.desktop -t $out/share/applications
    cp -a ${appimageContents}/usr/share/icons $out/share/

    substituteInPlace $out/share/applications/thorium.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A cross platform desktop reading app, based on the Readium Desktop toolkit";
    homepage = "https://github.com/edrlab/thorium-reader";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
