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
    rev = "353e310b705f5d1a5d8c8a3591c1ec3f1cc43878";
    hash = "sha256-XKxLXJs89ZWmfVTeO7hvuLieURj4R07Lq6KxsEgCfAs=";
  };

  # subPackages = [ "cmd" ];

  # proxyVendor = true;

  deleteVendor = true;

  vendorHash = "sha256-wt7HSpua9l5B2DncDdj+BoBJkr8dAeGWYTwR/ACEeoc=";

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
