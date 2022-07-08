{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  mpv,
  nix-update-script,
}:
buildGoModule rec {
  pname = "radioboat";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
    sha256 = "sha256-ZAKTWmK3hCJxm/578cjtdgMA2ZRhCFtzfGdta0gmuFY=";
  };

  vendorSha256 = "sha256-X3KiqaiOQYQBfVckh50C+4oxIVN6gXyNuQtBwGvjdFQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slashformotion/radioboat/internal/buildinfo.Version=${version}"
  ];

  nativeBuildInputs = [makeWrapper];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [mpv]}";
  '';

  passthru.updateScript = nix-update-script {attrPath = pname;};

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/slashformotion/radioboat";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
