{
  lib,
  fetchFromGitHub,
  rustPlatform,
  rustfmt,
  pkg-config,
  openssl,
  alsa-lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "clitrans";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AmIT6ubm24ZnRqLjcbGT9lSJGtQ30LaU/MEwak19nRg=";
  };

  cargoSha256 = "sha256-JWtp7amTZQ8eblZHmBMzQbAFLrQz/gIp/eA8VHOFuNw=";

  nativeBuildInputs = [pkg-config rustfmt];

  buildInputs = [
    openssl
    alsa-lib
  ];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false;

  meta = with lib; {
    description = "Yet another command-line translator";
    homepage = "https://github.com/wfxr/clitrans";
    platforms = platforms.all;
    license = with licenses; [mit mpl20];
    maintainers = with maintainers; [zendo];
  };
}
