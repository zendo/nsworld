# lack cargo.lock
{
  lib,
  fetchFromGitHub,
  rustPlatform,
  # pkg-config,
  # openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "mprober";
  version = "0.11.0-beta.11";

  src = fetchFromGitHub {
    owner = "magiclen";
    repo = "m-prober";
    rev = "v${version}";
    sha256 = "sha256-+Qz6U72THRBXZk2HQxE2Cjp6CcjrNY3Qik2AIYrlM+M=";
  };

  cargoSha256 = "sha256-mbqI1csnU95VWgax4GjIxB+nhMsspaeJ8QQ3qb0hY4c=";

  # nativeBuildInputs = [pkg-config];
  # buildInputs = [openssl];
  # OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Collect Linux system information";
    homepage = "https://github.com/magiclen/m-prober";
    license = [licenses.mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
