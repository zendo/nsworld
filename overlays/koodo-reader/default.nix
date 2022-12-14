{ lib
, stdenv
, fetchurl
, electron
, appimageTools
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "koodo-reader";
  version = "1.4.9";

  src = fetchurl {
    url = "https://github.com/troyeguo/koodo-reader/releases/download/v${version}/Koodo-Reader-${version}.AppImage";
    hash = "sha256-ShjaslhU7WFQyl/xUzgsI7/bawvvC2VdTdS2UNmuvn0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/${pname} $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/${pname}.desktop $out/share/applications/
    cp -a ${appimageContents}/usr/share/icons $out/share/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  # { lib, mkYarnPackage, fetchYarnDeps, fetchFromGitHub, electron, makeWrapper }:

  # mkYarnPackage rec {
  #   pname = "koodo-reader";
  #   version = "1.4.9";

  #   src = fetchFromGitHub {
  #     owner = "troyeguo";
  #     repo = pname;
  #     rev = "v${version}";
  #     hash = "sha256-qLd1UKY5vL3yK07QLR5MOWzoALPC8vkJVpsuzVHLYOU=";
  #   };

  #   offlineCache = fetchYarnDeps {
  #     yarnLock = src + "/yarn.lock";
  #     hash = "sha256-2n9qD9AsMPplyhguVFUss7TQYpOpsrw6XXjptbOaYF8=";
  #   };
  #   packageJSON = ./package.json;

  #   buildPhase = ''
  #     runHook preBuild
  #     yarn dev
  #     runHook postbuild
  #   '';
  #   distPhase = "true";
  #   dontInstall = true;
  #   dontFixup = true;

  # # The spectron dependency has to be removed manually from package.json,
  # # because it requires electron-chromedriver, which wants to download stuff.
  # # It is also good to remove the electron-builder bloat.
  # packageJSON = ./package.json;
  # yarnLock = ./yarn.lock;
  # yarnNix = ./yarn.nix;

  # yarnPreBuild = ''
  #   # workaround for missing opencollective-postinstall
  #   mkdir -p $TMPDIR/bin
  #   touch $TMPDIR/bin/opencollective-postinstall
  #   chmod +x $TMPDIR/bin/opencollective-postinstall
  #   export PATH=$PATH:$TMPDIR/bin

  #   export ELECTRON_SKIP_BINARY_DOWNLOAD=1
  # '';

  # # We build (= webpack) uivonim in a separate package,
  # # because this requires devDependencies that we do not
  # # wish to bundle (because they add 250M to the closure size).
  # build = mkYarnPackage {
  #   name = "uivonim-build-${version}";
  #   inherit version src packageJSON yarnLock yarnNix yarnPreBuild distPhase;

  #   buildPhase = ''
  #     yarn build:prod
  #   '';

  #   installPhase = ''
  #     mv deps/uivonim/build $out
  #   '';
  # };

  # # The --production flag disables the devDependencies.
  # yarnFlags = [ "--production" ];

  # nativeBuildInputs = [ makeWrapper ];

  # postInstall = ''
  #   dir=$out/libexec/uivonim/node_modules/uivonim/
  #   # need to copy instead of symlink because
  #   # otherwise electron won't find the node_modules
  #   cp -ra ${build} $dir/build
  #   makeWrapper ${electron}/bin/electron $out/bin/uivonim \
  #     --set NODE_ENV production \
  #     --add-flags $dir/build/main/main.js
  # '';

  # distPhase = ":"; # disable useless $out/tarballs directory

  meta = with lib; {
    description = "An open-source (FOSS) todo manager based on the todo.txt syntax";
    homepage = "https://github.com/troyeguo/koodo-reader";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
