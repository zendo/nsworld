{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:
# WIP!!!
buildGoModule rec {
  pname = "sing-box";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x9IXAET2FSUwGbiCJC4focQPpiGuuCjHq+TjIZarjhc=";
  };

  vendorSha256 = "sha256-TVA+oxUjIrzCp3KBlYgNNW8CRilWFBzp4WOF8i2Ug4g=";

  # subPackages = [ "cmd/sing-box" ];

  # CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sagernet/sing-box/constant.Commit=${version}"
  ];

  tags = [
    "with_quic"
    "with_grpc"
    "with_wireguard"
    "with_shadowsocksr"
    "with_ech"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_v2ray_api"
    "with_gvisor"
    # "with_lwip"
  ];

  # doCheck = false;
  excludedPackages = [ "./test" ];

  postInstall = ''
    installShellCompletion --cmd sing-box \
      --bash <($out/bin/sing-box completion bash) \
      --fish <($out/bin/sing-box completion fish) \
      --zsh <($out/bin/sing-box completion zsh)
  '';

  meta = with lib; {
    description = "The universal proxy platform";
    homepage = "https://github.com/SagerNet/sing-box";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
