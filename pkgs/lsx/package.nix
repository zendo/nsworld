{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lsx";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CJSen";
    repo = "lsx";
    rev = "v${version}";
    hash = "sha256-M7QgtKXrzfwq4IAt0gk6aupPS3oIndr2SDDJnNqDbP0=";
  };

  vendorHash = "sha256-spdf172sKsCuYI1VOni5bjH5v5+HTSbmmGTnK1HuJnU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Impressive Linux commands cheat sheet CLI written in Go";
    homepage = "https://github.com/CJSen/lsx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "lsx";
  };
}
