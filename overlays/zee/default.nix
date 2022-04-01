{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "zee";
  version = "git-45a8cf1";

  src = fetchFromGitHub {
    owner = "mcobzarenco";
    repo = pname;
    rev = "45a9cf195ca12cb5c2786a653f161599cbc156b9";
    # fetchSubmodules = true;
    sha256 = "sha256-MJgERLE2XWDBoSK/eUgUU4USqeBiV25kDK1+UN6Kve8=";
  };

  cargoSha256 = "sha256-CS0l6YdP1i122XUr2T6YHpH+Vx07gmKaSfM+UE6zKrA=";

  meta = with lib; {
    description = "A modern editor for the terminal, written in Rust.";
    homepage = "https://github.com/mcobzarenco/zee";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ zendo ];
    platforms = platforms.all;
  };
}
