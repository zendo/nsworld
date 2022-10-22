{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, installShellFiles
}:

# WIP!!

buildGoModule rec {
  pname = "go-musicfox";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "anhoder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/3FStiXK0FXa9Lz0tie3EZOQixKfV35y02rckJ7hag8=";
  };

  # subPackages = [ "cmd" ];

  # proxyVendor = true;

  deleteVendor = true;

  vendorHash = "sha256-McfVcXf1I1fSB+PnsLSrbPV7qGnL01P8tJAs8OiXodk=";

  CGO_ENABLED = 0;
  GOFLAGS = [ "-trimpath" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X go-musicfox/pkg/constants.AppVersion={{.Tag}}"
    "-X go-musicfox/pkg/constants.LastfmKey={{.Env.LASTFM_KEY}}"
    "-X go-musicfox/pkg/constants.LastfmSecret={{.Env.LASTFM_SECRET}}"
  ];

  # nativeBuildInputs = [ makeWrapper installShellFiles ];

  # preFixup = ''
  #   wrapProgram $out/bin/go-musicfox --prefix PATH ":" "${lib.makeBinPath [ mpv ]}";
  # '';

  # postInstall = ''
  #   cp -r * $out
  #   # installShellCompletion --cmd go-musicfox \
  #   #   --bash <($out/bin/go-musicfox completion bash) \
  #   #   --fish <($out/bin/go-musicfox completion fish) \
  #   #   --zsh <($out/bin/go-musicfox completion zsh)
  # '';

  meta = with lib; {
    description = "A terminal web radio client";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
