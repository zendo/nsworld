{ lib
, stdenv
, fetchFromGitHub
, file
, openssl
}:

stdenv.mkDerivation rec {
  pname = "stpv";
  version = "unstable-2022-06-15";

  src = fetchFromGitHub {
    owner = "Naheel-Azawy";
    repo = pname;
    rev = "516fd58f81b26ec2227ea6aed6d9200f15953f95";
    hash = "sha256-m60tvqmQMymqrv/9H+6AYayb8yS6GNKVYTh1dUavvyc=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple Terminal PreViewer";
    homepage = "https://github.com/Naheel-Azawy/stpv";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
