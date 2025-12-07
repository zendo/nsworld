{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-S60MtdCSaAF5PUyGGTnxWEr2ktuBaASlzt7YXTLQkpg=";
  };

  vendorHash = "sha256-2pIGoy5/ExNUDgw9OMcL26Rt3uy4pv1jgwpKpHj964I=";

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
