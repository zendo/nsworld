{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, cmake
, systemdMinimal
, alsa-lib
, fontconfig
, ncurses
, liberation_ttf
}:
# WIP!!!
rustPlatform.buildRustPackage rec {
  pname = "tiny-games";
  version = "999";

  src = fetchFromGitHub {
    owner = "JonathanMurray";
    repo = pname;
    rev = "36d74d5b2c0f58dc878265e81bcb0e1a467ce315";
    hash = "sha256-qPsiFRD4kTUwnvtkGcyU8UtMOEblBhnIQPvY7DH6Wu8=";
  };

  cargoHash = "sha256-yGxFPvRKLfymTwi3ptKF20QSdoW/kUthw+eeaQ62mhU=";

  nativeBuildInputs = [
    pkg-config
    cmake
  #   makeWrapper
  ];

  buildInputs = [
    # openssl
    alsa-lib
    fontconfig
    # liberation_ttf
    # ncurses
    systemdMinimal # libudev
  ];

  # preFixup = ''
  #   wrapProgram $out/bin/radio-cli \
  #     --prefix PATH ":" "${lib.makeBinPath [ mpv yt-dlp ]}";
  # '';

  meta = with lib; {
    description = "Games like Tetris and Snake make up tiny grid worlds that fit well within a termina";
    homepage = "https://github.com/JonathanMurray/tiny-games";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
