{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "git-hist";
  version = "unstable-2022-07-09";

  src = fetchFromGitHub {
    owner = "arkark";
    repo = pname;
    rev = "83bfa49543d2d5af8575326a0781f8fc52c1b3bf";
    sha256 = "sha256-xw4SbHDwVJKFEeQ7RvW9EeJb+a7gNk/KRxp+5MbtjYk=";
  };

  cargoSha256 = "sha256-qyAiStv4mi4QWky1Y3dc9UYSTas7hdFuHBREMTooZ0M=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Quickly browse the git history of files in your terminal";
    homepage = "https://github.com/arkark/git-hist";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [zendo];
  };
}
