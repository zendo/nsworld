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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "slashformotion";
    repo = "radioboat";
    rev = "v${version}";
    sha256 = "sha256-63O2nqT4HIK3Xo8VbNxVs0fwCmh/FUbok4P+nhpe3wI=";
  };

  vendorSha256 = "sha256-X3KiqaiOQYQBfVckh50C+4oxIVN6gXyNuQtBwGvjdFQ=";

  ldflags = ["-s" "-w"];

  nativeBuildInputs = [makeWrapper];

  preFixup = ''
    wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [mpv]}";
  '';

  postPatch = ''
    substituteInPlace cmd/root.go --replace "v0.0.1" "v${version}"
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
