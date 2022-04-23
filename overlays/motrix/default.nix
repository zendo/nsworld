# WIP
# Too many open files
{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  electron,
  makeWrapper,
}:
mkYarnPackage rec {
  pname = "motrix";
  version = "1.6.11";

  src = fetchFromGitHub {
    owner = "agalwood";
    repo = "Motrix";
    rev = "v${version}";
    sha256 = "sha256-foWG1nZOBU+TdUnRTdOXAi9wOpSQt5UakX+67bkj7QE=";
  };

  # packageJSON = ./package.json;
  # yarnLock = ./yarn.lock;
  # yarnNix = ./yarn.nix;
  # yarnFlags = [ "--production" "--offline" ];

  buildPhase = ''
    yarn --offline build
  '';

  distPhase = "true";

  meta = with lib; {
    homepage = "https://github.com/agalwood/Motrix";
    description = "A full-featured download manager supports HTTP, FTP, BitTorrent, Magnet";
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
