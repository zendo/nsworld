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
  version = "git-45a8cf1";

  src = fetchFromGitHub {
    owner = "mcobzarenco";
    repo = pname;
    rev = "45a9cf195ca12cb5c2786a653f161599cbc156b9";
    # fetchSubmodules = true;
    sha256 = "sha256-A4yp0XDi6nC5ZQNWLI7LEcFuSKayEz6MgO4FGU1ueWw=";
  };

  cargoSha256 = "sha256-CS0l6YdP1i122XUr2T6YHpH+Vx07gmKaSfM+UE6zKrA=";

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
