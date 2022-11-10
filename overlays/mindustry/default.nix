{ lib
, stdenv
, fetchurl
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, jre
}:

stdenv.mkDerivation rec {
  pname = "mindustry";
  version = "140.2";

  src = fetchurl {
    url = "https://github.com/Anuken/Mindustry/releases/download/v${version}/Mindustry.jar";
    hash = "sha256-MKiCRMefG4RO6TriYMAC20gsHFqYkC4xD8nU5wHsEQQ=";
  };

  # icon = fetchurl {
  #   url = "https://raw.githubusercontent.com/Shabinder/SpotiFlyer/v${version}/art/SpotiFlyer.svg";
  #   hash = "sha256-cYdVQsRVnTzgETX+TqJQt6jpsTLo1qVxdKnTGh5rnEE=";
  # };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/${pname} --add-flags "-jar $src"
    # install -Dm444 $icon $out/share/icons/hicolor/scalable/apps/SpotiFlyer.svg
    runHook postInstall
  '';

  # postInstall = ''
  #   wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [  ffmpeg-full ]}
  # '';

  desktopItems = [
    (makeDesktopItem {
      exec = "mindustry";
      name = "Mindustry";
      icon = "Mindustry";
      desktopName = "Mindustry";
      categories = [ "Game" ];
      comment = meta.description;
    })
  ];

  meta = with lib; {
    description = "The automation tower defense RTS";
    homepage = "https://github.com/Anuken/Mindustry";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
