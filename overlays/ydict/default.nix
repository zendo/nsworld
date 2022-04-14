{
  lib,
  libnotify,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "ydict";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "ydict";
    rev = "v${version}";
    sha256 = "sha256-zhjsXZsRk0UNijjqjGjZh4TiPxAM5p+ic3JMx2wrPeY=";
  };

  vendorSha256 = "sha256-O6czDfKD18rGVMIZv6II09oQu1w0ijQRuZRGt2gj9Cs=";

  # ldflags = ["-s" "-w" "-X=main.Version=${version}"];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/TimothyYe/ydict";
    description = "A command-line translator using Youdao online Chinese dictionary";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [maintainers.zendo];
  };
}
