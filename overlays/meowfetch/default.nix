{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
# , nix-update-script
# , testers
}:

buildGoModule rec {
  pname = "meowfetch";
  version = "unstable-2022-07-31";

  src = fetchFromGitHub {
    owner = "Itsnexn";
    repo = pname;
    rev = "51fc30091e8195e38678e3f46e434408d349f53c";
    sha256 = "sha256-+nFuQtj2UXFa5fiOMei7OrcOR998s9h9NRz8iGoCQVM=";
  };

  vendorSha256 = "sha256-PnkXXNr+kIige1YB/vEG+sYI0X/rr+6Gtcnb0rW4YK0=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage meowfetch.1
  '';

  # passthru = {
    #   updateScript = nix-update-script { attrPath = pname; };
    #   tests.version = testers.testVersion {
      #     package = gostatic;
      #     command = "gostatic -V";
      #     version = version;
      #   };
      # };

      meta = with lib; {
        description = "Minimal, fast and customizable system information program written in go";
        homepage = "https://github.com/Itsnexn/meowfetch";
        license = licenses.mit;
        maintainers = with maintainers; [ zendo ];
      };
}
