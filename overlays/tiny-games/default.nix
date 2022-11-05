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
    rev = "3f62c9a3fbe51748e528b5e4d3f5bf4a3b1136cf";
    hash = "sha256-xjZHSTNexza2F+3W1jliliDk84FCssl9C5LZYJxHpDM=";
  };

  cargoHash = "sha256-DVjc/Vn7c6i5pZa4ZRjUzVGQGkb9FlGihO7q6e3d80c=";

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
