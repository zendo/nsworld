{ lib
, stdenv
, fetchurl
, dpkg
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
  version = "1.2.3";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-uiw9kcXJ4ZEu+naUbUrgN/zBYE2bSWVPmMQ+HiAP4D4=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
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

    # works?
    makeWrapper $out/usr/bin/${pname} $out/bin/${pname} \
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
