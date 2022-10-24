{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libclang
, openssl
, alsa-lib
, ffmpeg-full
}:

rustPlatform.buildRustPackage rec {
  pname = "rustplayer";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "kingtous";
    repo = pname;
    rev = "latest";
    hash = "sha256-iaXaT5O6zDVBdCKeNQ+p/Gk6gXbTOus9com70HRfJXU=";
  };

  cargoHash = "sha256-2Wy/0jr/W0qmUSA59Y1eTBqJToZbb9PcIPItPVZSO7w=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    alsa-lib
    ffmpeg-full
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  doCheck = false;

  postInstall = ''
    ln -s $out/bin/RustPlayer $out/bin/rustplayer
  '';

  meta = with lib; {
    description = "A TUI audio player & m3u8 radio player written in Rust";
    homepage = "https://github.com/kingtous/rustplayer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
