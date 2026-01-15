{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "comigo";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "yumenaka";
    repo = "comigo";
    rev = "v${version}";
    hash = "sha256-TYQMYe4KkykLLA5pPfCe/036W2Yft67WHdPdFLV2vtg=";
  };

  vendorHash = "sha256-picAt4tEvzTRFZUAPxPwa1Y5qwn5IQ+ITr70UI6IEvU=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    rm $out/bin/comi
  '';

  meta = {
    description = "Simple and Efficient Comic Reader";
    homepage = "https://github.com/yumenaka/comigo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "comigo";
  };
}
