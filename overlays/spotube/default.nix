{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, appimage-run
, makeWrapper
, gtk3
, glib
}:
# dart failed!!!
stdenv.mkDerivation rec {
  pname = "spotube";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/KRTirtho/${pname}/releases/download/v${version}/Spotube-linux-x86_64.AppImage";
    hash = "sha256-B9oWApN+Exuf3FbbeRQA8D7iD+N04V9mbIOeXExKkr4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share $out/share/applications
    # cp -a ${appimageContents}/{locales,resources} $out/share/
    # cp -a ${appimageContents}/${pname}.desktop $out/share/applications/
    cp -a ${appimageContents}/usr/share/icons $out/share/
    # substituteInPlace $out/share/applications/${pname}.desktop \
      # --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  # postFixup = ''
  #   makeWrapper ${electron}/bin/electron $out/bin/${pname} \
  #     --add-flags $out/share/resources/app.asar \
  #     --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  #       # "${lib.strings.makeLibraryPath [gtk3 glib]}"
  # '';
  # # postFixup = ''
  # #   makeWrapper ${appimage-run}/bin/appimage-run $out/bin/${pname} \
  # #     --add-flags "$src" \
  # #     --prefix LD_LIBRARY_PATH : "${lib.strings.makeLibraryPath [gtk3 glib]}"
  # # '';

    meta = with lib; {
    description = "A lightweight free Spotify crossplatform-client desktop_computer";
    homepage = "https://github.com/KRTirtho/spotube";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
