{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "smartgit";
  version = "21.2";

  src = fetchurl {
    url = "https://www.syntevo.com/downloads/smartgit/smartgit-linux-21_2_4.tar.gz";
    hash = "sha256-9Jj4VqrEIsx2oFUoQsPEKaEcyKDR5SQF9tJ2r2w62CM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # dontUnpack = true;
  # dontConfigure = true;
  # dontBuild = true;

  installPhase = ''
    runHook preInstall

    runHook postInstall
  '';

  postFixup = ''

  '';

    meta = with lib; {
    description = "A simple music player capable of playing local audio or from Youtube or Spotify";
    homepage = "https://www.syntevo.com/smartgit/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
