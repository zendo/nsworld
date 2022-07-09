{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8BP5Flst+rM7T1Jp1dBsZTYOYKm8TyanxYvRH18aXck=";
  };

  cargoSha256 = "sha256-n2NOWrgcMVHpNCHL7r8+Kl1e01XYadaNM7UdE8fQo1U=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false;

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Convert images to ASCII art";
    homepage = "https://github.com/FineFindus/artem";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [zendo];
  };
}
