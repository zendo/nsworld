{ lib
, fetchFromGitHub
, buildGoModule
, mpv
, makeWrapper
, installShellFiles
, nix-update-script
, testers
, go-musicfox
}:

buildGoModule rec {
  pname = "go-musicfox";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "anhoder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uXCzUxDod6HpE2cQBTBs9+maSjNxxX2uBrbxCo+eBbA=";
  };

  # subPackages = [ "cmd" ];

  # proxyVendor = true;

  vendorHash = "sha256-3qW14KTASk15utv6pNQUyaYRvI3XMq0ob28r684jjw8=";

  # preBuild = ''
  #   export CGO_ENABLED=1
  # '';
  CGO_ENABLED = 0;

  # doCheck = false;

  # prePhases = ''
  #   rm -fr vendor
  # '';

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

  # passthru = {
  #   updateScript = nix-update-script { attrPath = pname; };
  #   tests.version = testers.testVersion {
  #     package = radioboat;
  #     command = "radioboat version";
  #     version = version;
  #   };
  # };

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
