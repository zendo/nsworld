{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation {
  pname = "sub-store";
  version = "2.15.12";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    sha256 = "sha256-KKwsi9yfgNqggHF4km9JW7RVK2lFMKq7y5asQA/tmN8=";
  };

  js = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js";
    sha256 = "sha256-XuHY07sHH83yl7vy5kWcC55wOCF9crNSha4lIh+w/AY=";
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
