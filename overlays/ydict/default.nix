{ lib, libnotify, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ydict";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "ydict";
    rev = "v${version}";
    sha256 = "1rix5dncfk3jffi9zrhc20zy5147v5l8rsiqi86lb4qikdfyq66f";
  };

  vendorSha256 = "sha256-O6czDfKD18rGVMIZv6II09oQu1w0ijQRuZRGt2gj9Cs=";

  # buildInputs = [ libnotify ];


  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # makeWrapperArgs = [
  #   "--prefix" "PATH" ":" (lib.makeBinPath [ libnotify ])
  # ];


  # postFixup = ''
  #   substituteInPlace $out/bin/ydict --replace "(notify-send " "(${libnotify}/bin/notify-send "
  #   '';

  meta = with lib; {
    homepage = "https://github.com/TimothyYe/ydict";
    description = "Yet another command-line youdao dictionary for geeks!";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.zendo ];
  };
}
