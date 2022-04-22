# WIP
{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  # cmake,
  # pkg-config,
}:

buildGoModule rec {
  pname = "Jacalz";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "Jacalz";
    repo = "rymdport";
    rev = "v${version}";
    sha256 = "sha256-IEZKyVAnHHhv0rYrEtUV22F26Z2t/SyRxabryjxbWUk=";
  };

  vendorSha256 = "sha256-55vAeGSJFIf3QctGLBaYmywm4Jp2haFq0MogjJqh+Qo=";

  # ldflags = ["-s" "-w" "-X=main.Version=${version}"];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Encrypted file, folder, and text sharing between devices";
    homepage = "https://github.com/Jacalz/rymdport";
    license = licenses.gpl3;
    maintainers = with maintainers; [zendo];
  };
}
