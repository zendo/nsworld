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
  version = "0.11.0-beta.12";

  src = fetchFromGitHub {
    owner = "magiclen";
    repo = "m-prober";
    rev = "v${version}";
    sha256 = "sha256-XFhgPwsmhBw7akeY1EFVeKNtS9KlnXmbCDhQgOIVydw=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "sha256-rAyUPwhur2+gmSSje590+UwmO91RoML5pj00SvyL7yY=";

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
