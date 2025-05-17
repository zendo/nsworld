{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "sub-store";
  version = "2.19.42";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    sha256 = "sha256-0v0KmrQKhH6fiqO8h50PePRFKIiidkay+/SueYv235I=";
  };

  js = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js";
    sha256 = "sha256-HaCzX8PBFHwACqvTLwzabexcqIrK8S563m621qyjw1M=";
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
    maintainers = with lib.maintainers; [ zendo ];
  };
}
