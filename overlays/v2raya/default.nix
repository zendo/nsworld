{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, lib
, stdenv
, udev
, wrapGAppsHook
, v2ray
, v2ray-geoip
, v2ray-domain-list-community
, symlinkJoin
}:

stdenv.mkDerivation rec {
  pname = "v2raya";
  version = "1.5.9.1698.1";

  src = fetchurl {
    url = "https://github.com/v2rayA/v2rayA/releases/download/v${version}/installer_debian_amd64_${version}.deb";
    hash = "sha256-iQax3ROf281D8LVXzZ1QgWLjiky+pQ3kWyRFUzjRHlE=";
  };

  desktopItem = makeDesktopItem {
    name = "v2rayA";
    icon = "v2rayA";
    exec = "v2raya %U";
    categories = [ "Office" ];
    comment = "Abricotine Markdown Editor";
    desktopName = "v2rayA";
    startupNotify = true;
  };

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    # wrapGAppsHook
  ];

  buildInputs = atomEnv.packages;

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "usr" "$out"
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
    makeWrapper $out/usr/bin/${pname} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }" \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray ]}" \
      --prefix XDG_DATA_DIRS ":" ${symlinkJoin {
        name = "assets";
        paths = [ v2ray-geoip v2ray-domain-list-community ];
      }}/share
  '';

  meta = with lib; {
    description = "Markdown editor with inline preview";
    homepage = "https://github.com/brrd/Abricotine";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
