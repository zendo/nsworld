{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, alsa-lib
, makeWrapper
, curl
, rustfmt
}:
# WIP!!
# openssl-sys v0.9.61 failed
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

  cargoPatches = [ ./cargo.patch ];

  cargoSha256 = "sha256-MQ3UmYx5a0ME44Udqbbo0Z6kiuiqx+vw4acW42P8430=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    rustfmt
  ];

  buildInputs = [
    openssl
    alsa-lib
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  # OPENSSL_DIR="${lib.getDev openssl}";
  # OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  # OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  # preBuild = ''
  #   export OPENSSL_DIR=${lib.getDev openssl}
  #   export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib
  # '';

  # doInstallCheck = stdenv.hostPlatform.libc == "glibc";

  doCheck = false;

  # preFixup = ''
  #   wrapProgram $out/bin/radio-cli \
  #     --prefix PATH ":" "${lib.makeBinPath [ mpv yt-dlp ]}";
  # '';

  # postPatch = ''
  #   substituteInPlace Cargo.lock \
  #     --replace "0.9.61" "0.9.72" \
  #     --replace "313752393519e876837e09e1fa183ddef0be7735868dced3196f4472d536277f" "7e46109c383602735fa0a2e48dd2b7c892b048e1bf69e5c3b1d804b7d9c203cb"
  # '';

  meta = with lib; {
    description = "Yet another command-line translator (Chinese <=> English)";
    homepage = "https://github.com/wfxr/clitrans";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ zendo ];
  };
}
