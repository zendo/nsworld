{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  # electron,
  makeWrapper,
}:


mkYarnPackage rec {
  pname = "clash-verge";
  version = "unstable-2022-04-23";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = "clash-verge";
    rev = "321963be832290ed83125af26fb8a550db9a8bd6";
    sha256 = "sha256-1ykb2zj0Sn2KH4YRzsIj6hDeeGOaH2w/waDIXqEdKuo=";
  };


  meta = with lib; {
    homepage = "https://github.com/zzzgydi/clash-verge";
    description = "A Clash GUI based on tauri";
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
