# WIP FAILED
{
  lib,
  crystal,
  fetchFromGitHub,
  gtk4,
  glib,
  libadwaita,
  gettext,
  gnome,
  jq,
  bash,
}:
crystal.buildCrystalPackage rec {
  pname = "collision";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-YLCwbp9ynlo0XnLH7GZy2aY3F9uJLPh4SJHI5NKcOaM=";
  };

  # buildInputs = [ bash ];
  # propagatedUserEnvPkgs = [ jq ];

  format = "shards";
  shardsFile = ./shards.nix;
  # lockFile = ./shard.lock;

  crystalBinaries.collision.src = "src/collision.cr";

  nativeBuildInputs = [
    gettext
    glib
    libadwaita
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  #   preConfigure = ''
  #   substituteInPlace src/kakoune/version.cr --replace \
  #     '`git describe --tags --always`' \
  #     '"${version}"'
  # '';

  # postInstall = ''
  #   install -Dm555 share/kcr/commands/*/kcr-* -t $out/bin
  #   install -Dm444 share/kcr/applications/kcr.desktop -t $out/share/applications
  #   install -Dm444 ${icon} $out/share/icons/hicolor/scalable/apps/kcr.svg
  #   cp -r share/kcr $out/share/
  # '';

  # installCheckPhase = ''
  #   $out/bin/kcr --help
  # '';

  meta = with lib; {
    homepage = "https://github.com/GeopJr/Collision";
    description = "A GUI tool to generate, compare and verify MD5, SHA-1, SHA-256 & SHA-512 hashes";
    license = licenses.bsd2;
    maintainers = with maintainers; [zendo];
    platforms = platforms.linux;
  };
}
