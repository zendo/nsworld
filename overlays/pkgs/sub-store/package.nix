{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "sub-store";
  version = "2.20.15";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    sha256 = "sha256-oCqAMh9nuz04OKip3V22zUqmOHptlHam690lYHRF2H8=";
  };

  js = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js";
    sha256 = "sha256-lFLt2nS4Jm/hd751p6vdF6bVQcKxGEt28F7aKStcuSc=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/frontend
    cp -r . $out/frontend
    cp $js $out/sub-store.bundle.js
  '';

  meta = {
    description = "All-in-One Subscription Manager for QX, Loon, Surge, Stash, Clash, SingBox, ShadowRocket, and More";
    homepage = "https://github.com/sub-store-org/Sub-Store";
    downloadPage = "https://github.com/sub-store-org/Sub-Store-Front-End";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
