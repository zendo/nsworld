{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  openssl,
  tree-sitter,
}:
rustPlatform.buildRustPackage rec {
  pname = "zee";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mcobzarenco";
    repo = pname;
    # rev = "refs/tags/v${version}";
    rev = "a8979be0819a7140648315c1e5fac052933f9b57";
    fetchSubmodules = true;
    sha256 = "sha256-qCslkvur8aHAveYsX9i7DGpqySbVr4uOHDh3G/VnCco=";
  };

  cargoSha256 = "sha256-mCNW0xsrbOBUOaa4YXpGjbQUNDnMjNNkLkH5Dm1FOI0=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl tree-sitter];
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "A modern editor for the terminal, written in Rust.";
    homepage = "https://github.com/mcobzarenco/zee";
    license = [licenses.mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
