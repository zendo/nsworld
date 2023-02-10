{ lib
, stdenv
, fetchFromGitHub
, flutter
, cmake
, pkg-config
, gtk3
, glib
, pcre2
, libunwind
, elfutils # libdw
, orc
, gst_all_1
, makeWrapper
  , libappindicator-gtk3
}:

# https://nixos.wiki/wiki/Flutter
flutter.mkFlutterApp rec {
  pname = "fclash";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "kingtous";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iPV0FTeM7m179rtQAz/ad/nSg2pWPZq5t47srjXIMdU=";
  };

  vendorHash = "sha256-+Lbiwg8Gy6n0v9OzisjmklcY/Zy/fQFhgzs8WL0yxOM=";

  sourceRoot = "source/linux";

  # preBuild = ''
  #   export HOME=$(mktemp -d)
  # '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libappindicator-gtk3
  ];

  # cmakeFlags = [
  #   "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  #   "-DCMAKE_INSTALL_RPATH=${placeholder "out"}/lib"
  # ];

  # NIX_LDFLAGS = "-rpath ${lib.makeLibraryPath self.buildInputs}";
  # LD_LIBRARY_PATH = lib.makeLibraryPath self.buildInputs;

  #   flutterExtraFetchCommands = ''
  #     M=$(echo $TMP/.pub-cache/hosted/pub.dartlang.org/matrix-*)
  #     sed -i $M/scripts/prepare.sh \
  #       -e "s|/usr/lib/x86_64-linux-gnu/libolm.so.3|/bin/sh|g"  \
  #       -e "s|if which flutter >/dev/null; then|exit; if which flutter >/dev/null; the
  # n|g"

  #     pushd $M
  #     bash scripts/prepare.sh
  #     popd
  #   '';

  # # replace olm dummy path
  # postConfigure = ''
  #   M=$(echo $depsFolder/.pub-cache/hosted/pub.dartlang.org/matrix-*)
  #   ln -sf ${olm}/lib/libolm.so.3 $M/ffi/olm/libolm.so
  # '';

  # postInstall = ''
  #   FAV=$out/app/data/flutter_assets/assets/favicon.png
  #   ICO=$out/share/icons
  #   install -D $FAV $ICO/fluffychat.png
  #   mkdir $out/share/applications
  #   cp $desktopItem/share/applications/*.desktop $out/share/applications
  #   for s in 24 32 42 64 128 256 512; do
  #     D=$ICO/hicolor/''${s}x''${s}/apps
  #     mkdir -p $D
  #     convert $FAV -resize ''${s}x''${s} $D/fluffychat.png
  #   done
  #   substituteInPlace $out/share/applications/*.desktop \
  #     --subst-var out
  # '';

  meta = with lib; {
    description = "A lightweight free Spotify crossplatform-client desktop_computer";
    homepage = "https://github.com/KRTirtho/spotube";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
