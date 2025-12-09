{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sub-store";
  version = "2.20.48";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/download/${finalAttrs.version}/sub-store.bundle.js";
    hash = "sha256-oHGRv/TCMfTnsaw0oQvMcZb8am4N6pQSBeIK35FALIE=";
  };

  ui = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    hash = "sha256-qC+BYzvs+G59GqDo3j+NKZSssl01KKUZiXmEHoIbmgk=";
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
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
