# # WIP
# {
#   lib,
#   mkYarnPackage,
#   fetchFromGitHub,
#   rustPlatform,
#   pkg-config,
#   openssl,
#   glib,
#   atk,
#   gtk3,
#   libappindicator-gtk3,
#   libsoup,
#   webkitgtk,
#   # electron,
#   makeWrapper,
# }:
# # let
# mkYarnPackage rec {
#   pname = "clash-verge";
#   version = "1.0.0";

#   src = fetchFromGitHub {
#     owner = "zzzgydi";
#     repo = "clash-verge";
#     rev = "v${version}";
#     sha256 = "sha256-TVXWPUbSYPN34y7WYK9Viy6Kkb5dK4x/jVuZpKuzYeg=";
#   };
#   gui = rustPlatform.buildRustPackage {
#     inherit pname version;
#     src = "${src}/src-tauri";

#     cargoSha256 = "sha256-CJttSlCy38kyaUBq7NYuXVOGKQUvP/goEJ/g3Hst44E=";
#     nativeBuildInputs = [pkg-config];
#     buildInputs = [
#       openssl
#       glib
#       atk
#       gtk3
#       libappindicator-gtk3
#       libsoup
#       webkitgtk
#     ];
#   };

#   meta = with lib; {
#     homepage = "https://github.com/zzzgydi/clash-verge";
#     description = "A Clash GUI based on tauri";
#     maintainers = with maintainers; [zendo];
#     platforms = platforms.linux;
#     license = licenses.gpl3;
#   };
# }

# { lib, fetchurl, appimageTools }:

# appimageTools.wrapType2 rec {
#   name = "clash-verge";
#   version = "1.0.0";

#   src = fetchurl {
#     url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.AppImage";
#     sha256 = "sha256-I9ZbFFPgG7ipPxu02H8W8NqrtfomeNIntBYdDGxyyg4=";
#   };

#   meta = with lib; {
#     homepage = "https://github.com/zzzgydi/clash-verge";
#     description = "A Clash GUI based on tauri";
#     maintainers = with maintainers; [zendo];
#     platforms = platforms.linux;
#     license = licenses.gpl3;
#   };
# }
