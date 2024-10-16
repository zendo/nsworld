{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  zenity,
}:

buildGoModule rec {
  pname = "trzsz-go";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-go";
    rev = "v${version}";
    hash = "sha256-g1fbgKTFS9aPAmnTeFYoymrDEoZ6BtzUhA2Z9SNYbsU=";
  };

  vendorHash = "sha256-AsrRHHBlzW5s/PtJSQ+hAgqUIYwDwoemQaerRV/QKX0=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/trzsz \
      --prefix PATH ":" "${lib.makeBinPath [ zenity ]}";
  '';

  meta = {
    description = "Simple SSH file transfer tools similar to lrzsz written in Go";
    homepage = "https://github.com/trzsz/trzsz-go";
    mainProgram = "trzsz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
