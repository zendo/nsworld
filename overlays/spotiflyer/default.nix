{ lib
, stdenv
, fetchurl
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, jre
, ffmpeg-full
}:

stdenv.mkDerivation rec {
  pname = "spotiflyer";
  version = "3.6.3";

  src = fetchurl {
    url = "https://github.com/Shabinder/SpotiFlyer/releases/download/v${version}/SpotiFlyer-linux-x64-${version}.jar";
    hash = "sha256-7FWLF7BcyYvuTZ4giN2L+hWgoUpx5Xziy49HbchUx7s=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Shabinder/SpotiFlyer/v${version}/art/SpotiFlyer.svg";
    hash = "sha256-cYdVQsRVnTzgETX+TqJQt6jpsTLo1qVxdKnTGh5rnEE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 $icon $out/share/icons/hicolor/scalable/apps/SpotiFlyer.svg

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $src" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-full ]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      exec = "spotiflyer";
      name = "SpotiFlyer";
      icon = "SpotiFlyer";
      desktopName = "SpotiFlyer";
      categories = [ "Music" ];
      comment = meta.description;
    })
  ];

  meta = with lib; {
    description = "Kotlin multiplatform music downloader, Supports Spotify/Gaana/Youtube Music/Jio Saavn/SoundCloud";
    homepage = "https://github.com/Shabinder/SpotiFlyer";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
