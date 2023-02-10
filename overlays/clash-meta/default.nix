{ lib
, fetchFromGitHub
, buildGoModule
}:

# https://github.com/NixOS/nixpkgs/pull/191365
buildGoModule rec {
  pname = "clash-meta";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "MetaCubeX";
    repo = "Clash.Meta";
    rev = "v${version}";
    sha256 = "sha256-xlrhDCvRWvDz6TsHj04x0ojTfL+gkhHLLy9VnJkETqI=";
  };

  vendorSha256 = "sha256-8cbcE9gKJjU14DNTLPc6nneEPZg7Akt+FlSDlPRvG5k=";

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Dreamacro/clash/constant.Version=${version}"
  ];

  # network required
  doCheck = false;

  postInstall = ''
    mv $out/bin/clash $out/bin/clash-meta
  '';

  meta = with lib; {
    description = "Another Clash Kernel";
    homepage = "https://github.com/MetaCubeX/Clash.Meta";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
  };
}
