{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "sub-store";
  version = "2.19.98";

  src = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip";
    sha256 = "sha256-bZ+llD5WpkUi6yz6YpehK9XrMlxD7GXJVjV1/mnZUAw=";
  };

  js = fetchurl {
    url = "https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js";
    sha256 = "sha256-8fIQYaCUQ7qSkY9ynH8f4P/E/PEL8dLh6nTgHIEUAzg=";
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
