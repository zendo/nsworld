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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "marcoradocchia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qifIxP1tpE+JOlTPUi1Kf62M6VNbXIW5cWj2uvmVz+c==";
  };

  cargoSha256 = "sha256-DoTsmWofnYtAHRv2I8+dKUX9mj0xoBiCNiFghh45+qs=";

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
