{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  openssl,
  webkitgtk_4_1,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "picacomic";
  version = "4.0.3";

  src = fetchurl {
    url = "https://github.com/wgh136/PicaComic/releases/download/v${version}/pica-comic_${version}_amd64.deb";
    hash = "sha256-ceXMu21PkuS2krhIkQHlsXsyEtTDQj67673tVVT+R+c=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk_4_1
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/local/lib/pica-comic usr/share $out
    ln -s $out/pica-comic/pica_comic $out/bin/picacomic

    substituteInPlace $out/share/applications/pica-comic.desktop \
      --replace-fail '/usr/local/lib/pica-comic/pica_comic %u' 'picacomic %u'

    runHook postInstall
  '';

  meta = {
    description = "Comic app built with Flutter, supporting multiple comic sources";
    homepage = "https://github.com/wgh136/PicaComic";
    mainProgram = "picacomic";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
}
