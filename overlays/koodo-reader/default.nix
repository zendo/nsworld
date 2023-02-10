{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
, electron
, makeWrapper
}:

# cat pkgs/servers/web-apps/hedgedoc/default.nix
mkYarnPackage rec {
  pname = "koodo-reader";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5H43kLxtjUvn4vwhdy3oCA8Iw+yQ+KBocQLemXiVhUA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-Qrn99eOKndbg+8zH5YEog0DwL5Jh18hCCEzVCg1uHu8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  distPhase = "true";

  configurePhase = ''
    cp -r "$node_modules" node_modules
    chmod -R u+w node_modules
  '';

  buildPhase = ''
    runHook preBuild

    # export HOME=$(mktemp -d)
    export NODE_OPTIONS=--openssl-legacy-provider
    yarn --offline build

    # patchShebangs node_modules
    # export PATH=$PWD/node_modules/.bin:$PATH

    runHook postbuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,koodo-reader}
    cp -r ./* $out/share/koodo-reader

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --argv0 "koodo-reader" \
      --add-flags "$out/share/koodo-reader"

    runHook postInstall
  '';

  meta = with lib; {
    description = "All-in-one ebook reader";
    homepage = "https://koodo.960960.xyz/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
