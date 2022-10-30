{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "hashrat";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "ColumPaget";
    repo = "Hashrat";
    rev = "v${version}";
    hash = "sha256-+3IPCJS++7CE0ZrJb62LCRrAn2J4uCF3a1oOzDoOW0w=";
  };

  configureFlags = [ "--enable-xattr" ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Command-line hash-generation utility";
    longDescription = ''
      Hashrat is a hash-generation utility that supports the md5, sha1, sha256, sha512, whirlpool,
      jh-244, jh256, jh-384 and jh-512 hash functions, and also the HMAC versions of those functions.
      It can output in 'traditional' format (same as md5sum and shasum and the like), or it's own format.
      Hashes can be output in octal, decimal, hexadecimal, uppercase hexadecimal or base64.
      It supports directory recursion, hashing entire devices, and generating a hash for an entire directory.
      It has a 'CGI' mode that can be used as a web-page to lookup hashes.
    '';
    homepage = "https://github.com/ColumPaget/Hashrat";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
