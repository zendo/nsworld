{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, installShellFiles
, flac
}:

buildGoModule rec {
  pname = "gtt-go";
  version = "999";

  src = fetchFromGitHub {
    owner = "eeeXun";
    repo = "GTT";
    rev = "98ff16df38b92e9b0a34fbaf464792656f8ab5de";
    hash = "sha256-xrIjDFq3eDMO+6TxruGBAM7d8cnNPn65nz/nsMT82lQ=";
  };

  # subPackages = [ "cmd/musicfox.go" ];
  # subPackages = [ "." ];

  # proxyVendor = true;

  vendorHash = "sha256-ZF86AYBf4YEKy4gFI+g+pKLg0tFiYBQ8ukHH9EgMQXw=";

  # doCheck = false;

  # ldflags = [
  #   "-s"
  #   "-w"
  # ];

  # nativeBuildInputs = [ makeWrapper installShellFiles ];

  # buildInputs = [ flac ];

  # postInstall = ''
  #   ln -s $out/bin/com.github.cassidyjames.dippi $out/bin/dippi
  # '';


  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/eeeXun/GTT";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
