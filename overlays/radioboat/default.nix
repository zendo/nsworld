{ lib, fetchFromGitHub, buildGoModule, nix-update-script }:

buildGoModule rec {
  pname = "radioboat";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
    sha256 = "sha256-Qsv5jeyvlsQNGz1/kizLKI9Q5WnNGcacx/iOrArqbZ8=";
  };

  vendorSha256 = "sha256-fttql4Z8mzhrYyoGmIwCDJSf4iMKHG7mtXObhjH5p2Q=";

  ldflags = [ "-s" "-w" ];

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
