{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.2.24";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-Hgc3CByEKZRff1oudtFftC1fLlNyMcibb3U9Y408gC0=";
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
