{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  fetchYarnDeps,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  electron,
}:
# WIP!!!
mkYarnPackage rec {
  pname = "weektodo";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "manuelernestog";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0UV4F8Mg2hbjhWnzZ7c49V59yVWqNT/4laXt9XPdWwI=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-PURpp3ox4klNSzXoDd6cMG5QOgIdTUW0F+scCbhSfCo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  distPhase = "true";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,${pname}}
    cp -r ./* $out/share/${pname}
    # cp deps/${pname}/dist/linux-unpacked/resources/app.asar $out/share/${pname}

    # for size in 16 32 128 256 512; do
    #   install -D deps/${pname}/build/icon.iconset/icon_''${size}x''${size}.png \
    #     $out/share/icons/hicolor/''${size}x''${size}/apps/${pname}.png
    # done

    # makeWrapper ${electron}/bin/electron $out/bin/${pname} \
    #   --argv0 "WeekToDo" \
    #   --add-flags "$out/share/${pname}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "WeekToDo";
      comment = meta.description;
      categories = [ "Office" ];
    })
  ];

  meta = with lib; {
    description = "A free minimalist weekly planner app focused on privacy";
    homepage = "https://weektodo.me";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
