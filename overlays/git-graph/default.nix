{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libgit2
}:

rustPlatform.buildRustPackage rec {
  pname = "git-graph";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = pname;
    rev = version;
    hash = "sha256-B5xnRh4odV4PAVTBtR4/y9ULViFCr5N3WGw+FfPn6QM=";
  };

  cargoHash = "sha256-LZLKFdkW8DqMnAzPURrt1V71elMwht/gJzdleYJfQ9k=";

  # nativeBuildInputs = [ pkg-config ];

  # buildInputs = [ libgit2 ];

  meta = with lib; {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
