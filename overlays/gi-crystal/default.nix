{ lib
, fetchFromGitHub
, crystal
, glib
, gtk4
, libadwaita
, gettext
, clang-tools
, gobject-introspection
}:

crystal.buildCrystalPackage rec {
  pname = "gi-crystal";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "hugopl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GKuosZII4SNYA63W/68MBP31rpeOphQK7uFhV5d5w7Q=";
  };

  format = "shards";
  lockFile = ./shard.lock;
  shardsFile = ./shards.nix;

  crystalBinaries.gi-crystal.src = "src/gi-crystal.cr";

  # doCheck = false;

  # crystalBinaries.collision.options = [ "--release" "--verbose" ];

  # nativeBuildInputs = [ clang-tools ];

  buildInputs = [
    # glib
    # gtk4
    # gettext
    # libadwaita
    gobject-introspection
  ];

  preInstall = ''
    substituteInPlace Makefile --replace \
      "+make --quiet -C ./spec/libtest" ""
  '';

  meta = with lib; {
    description = "Tool to generate Crystal bindings and user API for glib-based libraries";
    homepage = "https://github.com/hugopl/gi-crystal";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
