{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "qr-rs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "marcoradocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cjMuY17zJ2AamX2Clkiazdj1H5RM6XUk2MPLOyfAeQg=";
  };

  cargoSha256 = "sha256-d0rH9nTKyljoWi47Bl+d1AA0vrxphkOs5rljD9mC8JQ=";

  # https://nixpk.gs/pr-tracker.html?pr=179782

  # nativeBuildInputs = [pkg-config];

  # buildInputs = [openssl];

  # OPENSSL_NO_VENDOR = 1;

  # doCheck = false;

  # passthru.updateScript = nix-update-script {
  #   attrPath = pname;
  # };

  meta = with lib; {
    description = "Encode URLs or text into QR codes";
    homepage = "https://github.com/marcoradocchia/qr-rs";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [zendo];
  };
}
