{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  alsa-lib,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "code-radio-cli";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jasonwei512";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fqMUSiTspRuTjQ4A9msAswwd83AYuQd2736edEYMH/E=";
  };

  cargoSha256 = "sha256-W6qJlunIW48VlqsQlZRvKH41cQwf3zx5u70JS0feVZ8=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [
    openssl
    alsa-lib
  ];

  meta = with lib; {
    description = "A command line music client for Code Radio by freecodecamp";
    homepage = "https://github.com/jasonwei512/code-radio-cli";
    license = licenses.mit;
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
  };
}
