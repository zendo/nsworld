{ lib
, stdenv
, fetchurl
, dpkg
, atomEnv
, autoPatchelfHook
, makeWrapper
, udev
# , v2ray
# , v2ray-geoip
# , v2ray-domain-list-community
, symlinkJoin
}:
let
  inherit ((builtins.getFlake
    "github:NixOS/nixpkgs/8de8b98839d1f20089582cfe1a81207258fcc1f1").legacyPackages.${stdenv.system})
    # v2ray 4
    v2ray v2ray-geoip v2ray-domain-list-community;
in
stdenv.mkDerivation rec {
  pname = "v2raya";
  version = "1.5.9.1698.1";

  src = fetchurl {
    url = "https://github.com/v2rayA/v2rayA/releases/download/v${version}/installer_debian_amd64_${version}.deb";
    hash = "sha256-iQax3ROf281D8LVXzZ1QgWLjiky+pQ3kWyRFUzjRHlE=";
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

  buildInputs = atomEnv.packages;

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "usr" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    install -Dm 444 usr/share/applications/v2raya.desktop -t $out/share/applications
    cp -a usr/share/icons $out/share/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Icon=/usr/share/icons/hicolor/512x512/apps/v2raya.png' 'Icon=${pname}'
  '';

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
    description = "A web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
