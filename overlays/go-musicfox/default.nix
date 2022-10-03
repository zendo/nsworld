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
    rev = "16a61e176971a74f2a744e9f156b0acd22d02da7";
    hash = "sha256-3soa0xmVTQUocFFulsZU+dtyZJTM997ufTho1A7TPbU=";
  };

  # subPackages = [ "cmd" ];

  # proxyVendor = true;

  deleteVendor = true;

  vendorHash = "sha256-Tm0Uo9nkgiaUlKOXLvyxlP1PSuG3JCWIBCGdVqFAbL0=";

  CGO_ENABLED = 0;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    # "-X github.com/slashformotion/go-musicfox/internal/buildinfo.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  # preFixup = ''
  #   wrapProgram $out/bin/go-musicfox --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  # '';

  postInstall = ''
    cp -r * $out
    # installShellCompletion --cmd go-musicfox \
    #   --bash <($out/bin/go-musicfox completion bash) \
    #   --fish <($out/bin/go-musicfox completion fish) \
    #   --zsh <($out/bin/go-musicfox completion zsh)
  '';

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
