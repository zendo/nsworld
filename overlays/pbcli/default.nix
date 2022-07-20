{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "pbcli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mydayyy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JaM/t1e8pNZ8KNens60aHz6ktbrFrfwtEYXFlCjD+xs=";
  };

  cargoSha256 = "sha256-ccymtxnunRmrh8gvVE+OchmI7X9hHz1lwRDaEW5hjrI=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl];

  meta = with lib; {
    description = "Upload and download pastes from privatebin";
    homepage = "https://github.com/mydayyy/pbcli";
    platforms = platforms.all;
    license = with licenses; [mit unlicense];
    maintainers = with maintainers; [zendo];
  };
}
