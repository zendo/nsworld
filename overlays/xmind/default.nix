{ lib
, stdenv
, fetchurl
, dpkg
, atomEnv
, autoPatchelfHook
, makeWrapper
, makeDesktopItem
, wrapGAppsHook
, udev
}:

stdenv.mkDerivation rec {
  pname = "xmind";
  version = "22.10.0920";

  src = fetchurl {
    url = "https://dl3.xmind.net/Xmind-for-Linux-amd64bit-${version}.deb";
    hash = "sha256-jU20cQrP7lABTr3QtSMPIGEJBHlI7LjKBGFQjoDyznU=";
  };

  desktopItem = makeDesktopItem {
    name = "Xmind";
    icon = "net.xmind.XMind";
    exec = "xmind %U";
    categories = [ "Office" ];
    comment = "Xmind - The most popular mind mapping software";
    desktopName = "Xmind";
    startupNotify = true;
    # StartupWMClass= "Xmind";
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = atomEnv.packages;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    mkdir -p "$out/share/applications"
    # cp -r ./* "$out/share/applications" # for test
    cp "${desktopItem}/share/applications/"* "$out/share/applications"
  '';

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  postFixup = ''
    makeWrapper $out/opt/Xmind/${pname} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Mind Mapping & Brainstorming";
    homepage = "https://xmind.app";
    # license = licenses.bsd3;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
