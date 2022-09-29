{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "confetty";
  version = "unstable-2022-06-29";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = pname;
    rev = "da58df8393c2212f4565f20c04dc94930de7960b";
    hash = "sha256-qWBphbnyvQWdcfTHzV2jK2hnCg6qDCCqvH+Ajle7CEg=";
  };

  vendorHash = "sha256-Ivu1DAKyZuhwMp43xHhCHaXEwevT37f1QKhRQ6S1qns=";

  meta = with lib; {
    description = "Throwing confetti or fireworks in TTY";
    homepage = "https://github.com/maaslalani/confetty";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
