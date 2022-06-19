{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "frei";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${version}";
    sha256 = "sha256-S66P/p74UEW91+0x6oszNkgAZBTxm3mJBhwYyeG870s=";
  };

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  ldflags = ["-s" "-w" "-X=main.Version=${version}"];

  meta = with lib; {
    description = "Modern replacement command free";
    homepage = "https://github.com/alexcoder04/frei";
    license = licenses.gpl3;
    maintainers = with maintainers; [zendo];
  };
}
