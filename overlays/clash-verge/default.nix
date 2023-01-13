{ lib
, stdenv
, fetchurl
, dpkg
, atomEnv
, autoPatchelfHook
, makeWrapper
, udev
, openssl
, webkitgtk
, libcap
, libappindicator-gtk3
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-5150LH4A30Bbs91NbKV0GinOR+j2r+I+Xuj9q0Ga0IQ=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = atomEnv.packages ++ [
    openssl
    webkitgtk
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libappindicator-gtk3
    libayatana-appindicator
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r usr $out
    cp -r usr/share $out/share

    makeWrapper $out/usr/bin/${pname} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }" \
      --prefix PATH : "${lib.makeBinPath [ libcap ]}"
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri. Supports Windows, macOS and Linux";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
