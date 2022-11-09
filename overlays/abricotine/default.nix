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
}:

stdenv.mkDerivation rec {
  pname = "abricotine";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/brrd/abricotine/releases/download/v${version}/abricotine_${version}_amd64.deb";
    hash = "sha256-AWJ8nusGPGqPdfEZ5BqwFMbsICNHMQQ/UHyejX+/bPs=";
  };

  desktopItem = makeDesktopItem {
    name = "Abricotine";
    icon = "abricotine";
    exec = "abricotine %U";
    categories = [ "Office" ];
    comment = "Abricotine Markdown Editor";
    desktopName = "Abricotine";
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
    makeWrapper $out/opt/Abricotine/abricotine $out/bin/abricotine \
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }" \
    "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "Markdown editor with inline preview";
    homepage = "https://github.com/brrd/Abricotine";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
