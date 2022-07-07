# wip failed
{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hysteria";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "HyNetwork";
    repo = "hysteria";
    rev = "v${version}";
    sha256 = "sha256-V+umf7+qRANSNsMrU1Vij3ni6ayq/d41xSy3o+7sEHQ=";
  };

  vendorSha256 = "sha256-1wbM76MywRFBStDl9Ai4JlLVg4VkfVKQsezffxN9lXU=";

  ldflags = ["-s" "-w"];

  # subPackages = ["cmd" "pkg"];

  # excludedPackages = ["cmd"];

  meta = with lib; {
    description = "A feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/HyNetwork/hysteria";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
