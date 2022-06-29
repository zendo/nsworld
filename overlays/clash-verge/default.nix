# wip
{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  libthai,
  makeWrapper,
  autoPatchelfHook,
  desktop-file-utils,
  fetchFromGitHub,
  electron,
  desktopToDarwinBundle,
  copyDesktopItems,
}: let
  pname = "clash-verge";
  version = "1.0.3";

  name = "clash-verge-${version}";
  nameExecutable = pname;

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.AppImage";
    sha256 = "sha256-9OJ4JtfDFs7vdSIpikURw5A5L0e9+CnXUSCOOFlHqLU=";
  };

  appimageContents = appimageTools.extractType2 {inherit name src;};
in
  appimageTools.wrapType2 rec {
    inherit name src;
    # pname = "clash-verge";
    # version = "1.0.3";

    # src = fetchurl {
    #   url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.AppImage";
    #   sha256 = "sha256-9OJ4JtfDFs7vdSIpikURw5A5L0e9+CnXUSCOOFlHqLU=";
    # };

    extraPkgs = pkgs:
      (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
      ++ [pkgs.libthai];

    meta = with lib; {
      description = "Unofficial netease cloud music player based on Rust + GTK";
      homepage = "https://github.com/gmg137/netease-cloud-music-gtk";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [zendo];
    };
  }
