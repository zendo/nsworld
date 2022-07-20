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

  meta = with lib; {
    description = "Get Private/Public IP/IP's Geolocation";
    homepage = "https://git.mahdi.pw/getip";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [zendo];
  };
}
