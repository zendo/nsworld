{ lib
, fetchFromGitHub
, rustPlatform
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "moji";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "syedahkam";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-66B5KYmtN6lOfUBJQfEh2RZit5c2eDNnjQkjh4AEnus=";
  };

  cargoHash = "sha256-QAZi9WNPUP4qxaMdxC2EC2kI2GP6Sy7JK/+C0707Dl0=";

  buildInputs = [ libxcb ];

  postInstall = ''
    ln -s $out/bin/moji $out/bin/moji-rs
  '';

  meta = with lib; {
    description = "An emoji fuzzy finder cli written in rust";
    homepage = "https://github.com/syedahkam/moji";
    # license = licenses.unlicense;
    maintainers = with maintainers; [ zendo ];
  };
}
