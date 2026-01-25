{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-TmgYR1yeIXHgkUAdNTv80oKpM35dDD4esVC5vTrgRuA=";
  };

  vendorHash = "sha256-9oA/0s55RsQiBvftbzfoiHSVZ22GWXTq7VtjKwIDaD4=";

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
