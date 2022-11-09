{ lib
, stdenv
, fetchFromGitHub
, flutter
, cmake
, pkg-config
, gtk3
, glib
, makeWrapper
}:

flutter.mkFlutterApp rec {
  pname = "spotube";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "KRTirtho";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gLDTGKpdmLQOnpsUqd5H1LwqZ2+255gdRMi4rfp8fOI=";
  };

  vendorHash = "sha256-1PDX023WXRmRe/b1L+6Du91BvGwYNp3YATqYSQdPrRY=";

  # sourceRoot = "source/linux";

  # preBuild = ''
  #   export HOME=$(mktemp -d)
  # '';

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    glib
    gtk3
  ];

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

  meta = with lib; {
    description = "A lightweight free Spotify crossplatform-client desktop_computer";
    homepage = "https://github.com/KRTirtho/spotube";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
