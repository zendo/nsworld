{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "tfetch";
  version = "2022-06-25";

  src = fetchFromGitHub {
    owner = "Thamognya";
    repo = "TFetch";
    rev = "66988cb97163f940e2d91dae4d80ddc12b796b9a";
    sha256 = "sha256-tYIhZJNhjKeBwYWGyruBcdgiPX6pw6B5dlc37qLLSqU=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    description = "A simple fetching application that is light weight and fast";
    homepage = "https://github.com/Thamognya/TFetch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [zendo];
  };
}
