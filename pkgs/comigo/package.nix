{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.2.23";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-j1QtSOcZGs5mi3GRLc39pJFcOJWMDW7hc+viAn9sYIs=";
  };

  vendorHash = "sha256-IEYtO875L/y47IYsDRpeM19/tOjjwevgZWxHgLD6bmo=";

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
