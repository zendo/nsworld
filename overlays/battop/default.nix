# wip failed
{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "battop";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "svartalf";
    repo = "rust-battop";
    rev = "v${version}";
    sha256 = "sha256-PHh1bL9ESc5PXbq4JoT+l7/UkMz/w+1ETTxckQeVo1w=";
  };

  cargoSha256 = "sha256-7wj34YVcoFhgGWlMtv1MROwx6d1FhDqkUeQJjohjcAI=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];
  # OPENSSL_NO_VENDOR = 1;
  # doCheck = false;

  meta = with lib; {
    description = "Interactive batteries viewer";
    homepage = "https://github.com/svartalf/rust-battop/";
    license = with licenses; [mpl20 mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
