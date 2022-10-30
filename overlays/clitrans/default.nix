{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, alsa-lib
, makeWrapper
, curl
}:
# WIP!!
rustPlatform.buildRustPackage rec {
  pname = "clitrans";
  version = "999";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    # rev = "v${version}";
    rev = "bcb4794aea4eecb85771d1a3b4a0c5de66f23bec";
    hash = "sha256-Ufl5DjEICf8GnGfdh/wOHO+l5ZZkA6tK0IzoxlyKnyQ=";
  };

  cargoHash = "sha256-0m0ZrCP5PPdVgljRLOWL1q3jgTu0/CEW9UhDnykYXho=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
    alsa-lib
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_DIR="${lib.getDev openssl}";
  # OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  # OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  # cargoBuildFlags = [ "--features" "audio" ];

  # doCheck = false;

  # preFixup = ''
  #   wrapProgram $out/bin/radio-cli \
  #     --prefix PATH ":" "${lib.makeBinPath [ mpv yt-dlp ]}";
  # '';

  meta = with lib; {
    description = "Yet another command-line translator (Chinese <=> English)";
    homepage = "https://github.com/wfxr/clitrans";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ zendo ];
  };
}
