{ lib
, fetchFromGitHub
, crystal
, glib
, gtk4
, libadwaita
, gettext
, gobject-introspection
}:

crystal.buildCrystalPackage rec {
  pname = "collision";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "Collision";
    rev = "v${version}";
    hash = "sha256-tzvQF4Gn0ppbst/fV4BGZuXEe7SXJBWcN6uIOXB2huc=";
  };

  format = "shards";
  lockFile = ./shard.lock;
  shardsFile = ./shards.nix;

  crystalBinaries.collision.src = "src/collision.cr";

  # crystalBinaries.collision.options = [ "--release" "--verbose" ];

  # nativeBuildInputs = [ libadwaita ];

  buildInputs = [
    glib
    gtk4
    gettext
    libadwaita
    gobject-introspection
  ];

  # propagatedUserEnvPkgs = [ libadwaita ];
}
