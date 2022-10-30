{ lib
, fetchFromSourcehut
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "garbage";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~mzhang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GirPUl+YLikHf9sA16LkE9oqLCj1gfcOVva0ztZVjiI=";
  };

  cargoHash = "sha256-bWJdgTxNP7yCuCoB7fu0OWNY9NrJXIEbpDJC90qQ83k=";

  meta = with lib; {
    description = "Rust ver of trash-cli";
    homepage = "https://git.sr.ht/~mzhang/garbage";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
