# WIP
# Stderr: fatal: unable to access
# 'https://github.com/tree-sitter/tree-sitter-bash/': Could not resolve host: github.com
{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  tree-sitter,
}:
rustPlatform.buildRustPackage rec {
  pname = "zee";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "mcobzarenco";
    repo = pname;
    rev = "v${version}";
    # fetchSubmodules = true;
    sha256 = "sha256-/9SogKOaXdFDB+e0//lrenTTbfmXqNFGr23L+6Pnm8w=";
  };

  cargoSha256 = "sha256-mbqI1csnU95VWgax4GjIxB+nhMtmpaeJ8QQ3qb0hY4c=";

  # postPatch = ''
  #   patchShebangs scripts/build
  # '';

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl tree-sitter];
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Modern editor for the terminal";
    homepage = "https://github.com/mcobzarenco/zee";
    license = [licenses.mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
