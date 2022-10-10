{ lib
, stdenv
, fetchFromGitHub
, file
, openssl
}:

stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0OuskRCBVm8vMd2zH5u5EPABmCOlEv5N4ZZMdc7bAwM=";
  };

  buildInputs = [
    file # libmagic
    openssl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Previews for lf file manager";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
