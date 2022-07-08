{
  lib,
  stdenv,
  fetchgit,
}:
stdenv.mkDerivation {
  name = "getip";

  src = fetchgit {
    url = "git://mahdi.pw/getip.git";
    sha256 = "sha256-Bve8VacV0b3j4RX4kfrAIKmky3XRwVXts7z6olfM/gY=";
  };

  installPhase = ''
    install -Dm755 $name "$out/bin/getip"
  '';
}
