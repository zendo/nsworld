{ lib
, stdenv
, fetchurl
, dpkg
, atomEnv
, autoPatchelfHook
, makeWrapper
, udev
, xorg
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "notebook";
  version = "2.0.4";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/notebooklinux-desktop/Notebook-${version}.deb";
    hash = "sha256-ffUKn3z7PX/X3224ZbXBh8YnFDkDaFDe9f5tOhyERp8=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = atomEnv.packages ++ [
    stdenv.cc.cc
    xorg.libxshmfence
  ];

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    cp -r usr $out
    cp -r usr/share $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=/opt/Notebook/notebook %U' 'Exec=${pname} %U'

    makeWrapper $out/opt/Notebook/${pname} $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }"
  '';

  meta = with lib; {
    description = "The most beautiful note-taking app across devices";
    homepage = "https://www.zoho.com/notebook";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
