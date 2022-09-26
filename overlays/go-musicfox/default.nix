{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, installShellFiles
}:

buildGoModule rec {
  pname = "go-musicfox";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "anhoder";
    repo = pname;
    # rev = "v${version}";
    rev = "709f2bf1d1cef1e24f528dacf565b17a5fd00072";
    hash = "sha256-eQ9UlxZo51I1+jnafHbfXd4YS220Uq4hvEfZB1j0mQg=";
  };

  # subPackages = [ "cmd" ];

  # proxyVendor = true;

  deleteVendor = true;

  vendorHash = "sha256-P9pj4ez+fgC0H75C6kZBPfnLpfrz8XPfF/pNjZkySlc=";

  CGO_ENABLED = 0;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    # "-X github.com/slashformotion/radioboat/internal/buildinfo.Version=${version}"
  ];

  # nativeBuildInputs = [ makeWrapper installShellFiles ];

  # preFixup = ''
  #   wrapProgram $out/bin/radioboat --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  # '';

  # postInstall = ''
  #   installShellCompletion --cmd radioboat \
  #     --bash <($out/bin/radioboat completion bash) \
  #     --fish <($out/bin/radioboat completion fish) \
  #     --zsh <($out/bin/radioboat completion zsh)
  # '';

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
