{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "mabel";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "smmr-software";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-o+jVviOpW9uy2Qf7W/yyLGRn7r+97NNDNJDEn/R+fb8=";
  };

  vendorSha256 = "sha256-jHkKeuJ17qBa7+iPwYptgCW2Nwy+OidsxLl9QQfn/ks=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    install -Dm644 mabel.desktop "$out/share/applications/mabel.desktop"
  '';

  meta = with lib; {
    description = "A fancy BitTorrent client for the terminal";
    homepage = "https://github.com/smmr-software/mabel";
    changelog = "https://github.com/smmr-software/mabel/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
