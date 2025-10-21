{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sub-store";
  version = "2.20.31";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/download/${version}/sub-store.bundle.js";
    sha256 = "sha256-6fyo3Ausn0a8TL5Y9g/gmMkjCks6NrQcWZYESnI34Tw=";
  };

  ui = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    sha256 = "sha256-G6nzR1mnQqHGORC6MK5F9nv5eL2szRM6RrYCtwbg/U4=";
  };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/frontend
    unzip -j $ui -d $out/frontend
    cp $src $out/sub-store.bundle.js
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
