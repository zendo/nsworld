{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.2.19";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-32fopgH2DIJDpWrYqZjKA0+Kx0U/xne6XnJs0JUR794=";
  };

  vendorHash = "sha256-jWUWq7NFkeTfc5LfGPDaS0YBYja8w1Si+9kI51rS3T0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple and Efficient Comic Reader";
    homepage = "https://github.com/yumenaka/comigo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "comigo";
  };
}
