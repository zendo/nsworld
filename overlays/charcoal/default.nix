{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "charcoal";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "LighghtEeloo";
    repo = "Charcoal";
    rev = "v${version}";
    hash = "sha256-xkUhQM+ZXGZffGXA/xVheJdZfLBFGJBT1T5FU9zaV44=";
  };

  cargoHash = "sha256-BuOb0Lj2FDe3ZlYy364kGu6fx+dFrKJqAfLXiMaYhxM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib
  ];

  meta = with lib; {
    description = "An online dictionary using youdao dict api";
    homepage = "https://github.com/LighghtEeloo/Charcoal";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
