{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, tree-sitter, }:

rustPlatform.buildRustPackage rec {
  pname = "zee";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "mcobzarenco";
    repo = pname;
    # rev = "refs/tags/v${version}";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-0vHvzxdtxTsGVq1iJezjHCB0NKF5bCqMIrD15gOWcvE=";
  };

  cargoSha256 = "sha256-eXCbTM6+oLRIY4LIlrFs53V8IqYGhZyku48AgXmeYs8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl tree-sitter ];
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Modern editor for the terminal";
    homepage = "https://github.com/mcobzarenco/zee";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ zendo ];
    platforms = platforms.all;
  };
}
