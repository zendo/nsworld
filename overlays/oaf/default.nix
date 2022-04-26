{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "oaf";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "abentley";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ngdvuJhAngKbXafd2r5N6+Pzx2LK7NVd7c07edUrRy8=";
  };

  cargoSha256 = "sha256-GbQyww1gg2r1gWFAKkXjeJ+Osui8D9IB6dz9tkE2QVo=";

  meta = with lib; {
    description = "A Git client that brings a more user-friendly CLI to Git";
    homepage = "https://github.com/abentley/oaf";
    license = [licenses.mit];
    maintainers = with maintainers; [zendo];
    platforms = platforms.all;
  };
}
