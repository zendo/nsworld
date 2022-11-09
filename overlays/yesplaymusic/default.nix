{ lib, fetchurl, appimageTools }:

let
  pname = "yesplaymusic";
  version = "0.4.5";

  src = fetchurl {
    url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-${version}.AppImage";
    hash = "sha256-9Jj4VqrEIsx2oFUoQaPEKaEcyKDR5SQF9tJ2r2w62CM=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # extraPkgs = pkgs: with pkgs; [
  #   libsecret
  # ];

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
    homepage = "https://github.com/qier222/YesPlayMusic";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
