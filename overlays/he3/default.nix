{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, udev
, mesa # for libgbm
, cups
, nss
, nspr
, libdrm
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "he3";
  version = "1.2.9";

  src = fetchurl {
    url = "https://he3-1309519128.cos.accelerate.myqcloud.com/${version}/He3_linux_amd64_${version}.deb";
    hash = "sha256-4/8qjPSS5D+JCwqaJoHEImwDZK4x4vPbxxKksNJwwsc=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    mesa # for libgbm
    cups
    nss
    nspr
    libdrm
    alsa-lib
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt/He3 $out
    cp -r usr/share $out
    ln -s $out/He3/${pname} $out/bin/${pname}

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace '/opt/He3/he3' 'he3'
  '';

  meta = with lib; {
    description = "A Free, Modern Toolbox Built for Developers";
    homepage = "https://he3.app";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
