{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  nix-update-script,
}:
buildGoModule rec {
  pname = "gls";
  version = "2022-02-20";

  src = fetchFromGitHub {
    owner = "ad-on-is";
    repo = "gls";
    rev = "927352127ec793f0272e334ee5ad3099dc42d351";
    sha256 = "sha256-XEbqvhY1Mr+nkEoOQ6IlZw5DX8EwoLQCK30NUNmeYUI=";
  };

  vendorSha256 = "sha256-6vUrOepfejuUnixCnjel79xieChiZI1zGuOA+CVeAmg=";

  ldflags = ["-s" "-w"];

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/HyNetwork/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
