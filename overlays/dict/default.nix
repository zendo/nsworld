{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "dict";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "BetaPictoris";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8/uH/u9s6l8OMynwGTCoEKoSCpp5jm1WgQ0Vpads7wU=";
  };

  vendorSha256 = "sha256-hnsm/IIazfuFXykOd8yW5DeseluSoFTcjyUKblelQcE=";

  ldflags = ["-s" "-w"];

  passthru.updateScript = nix-update-script {attrPath = pname;};

  meta = with lib; {
    description = "View the dictionary through the CLI";
    homepage = "https://github.com/BetaPictoris/dict";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [zendo];
  };
}
