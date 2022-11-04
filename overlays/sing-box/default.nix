{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:
# WIP!!!
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=sing-box
buildGoModule rec {
  pname = "sing-box";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rt/hk3tYiBbLeUklpblD9w+4KSGHZTDAhaXSV5R3wFE=";
  };

  vendorHash = "sha256-nHtYTCd59rMIcstFjw62dxVH6CJl91yx9EBz2FrwSoo=";

  subPackages = [ "cmd/sing-box" ];

  # CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd sing-box \
      --bash <($out/bin/sing-box completion bash) \
      --fish <($out/bin/sing-box completion fish) \
      --zsh <($out/bin/sing-box completion zsh)
  '';

  # doCheck = false;

  meta = with lib; {
    description = "The universal proxy platform";
    homepage = "https://github.com/SagerNet/sing-box";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
