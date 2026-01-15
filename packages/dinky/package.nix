{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dinky";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sedwards2009";
    repo = "dinky";
    rev = "v${version}";
    hash = "sha256-m4mdTM2DjVVPyxeMiP2T9lHdGy7KLLupmXPKXFNSIMg=";
  };

  vendorHash = "sha256-alW/5Wg0Ejfmsj9kUC7UKmVUzQmEgclOlWNTUG4sIFU=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Small and friendly terminal based text editor";
    homepage = "https://github.com/sedwards2009/dinky";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "dinky";
  };
}
