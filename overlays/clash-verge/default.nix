{ lib
, stdenv
, fetchurl
, dpkg
, atomEnv
, autoPatchelfHook
, makeWrapper
, udev
, webkitgtk
, openssl
, libappindicator-gtk3
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-7Btnf+/jW3KbaVHzAp/jb6TVs9NNuQEfDF+uZ985Le0=";
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = atomEnv.packages ++ [
    webkitgtk
    openssl
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libappindicator-gtk3
    libayatana-appindicator
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "usr" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"
  '';

  postFixup = ''
    makeWrapper $out/usr/bin/${pname} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }"
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri. Supports Windows, macOS and Linux";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
