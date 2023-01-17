{ lib
, fetchCrate
, rustPlatform
, pkg-config
, openssl
, alsa-lib
}:

rustPlatform.buildRustPackage rec {
  pname = "charcoal-dict";
  version = "0.2.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FfrhCxz9wRFY6BGgpTcncXOsYtRBpc0PTnUOuYSWPtQ=";
  };

  cargoHash = "sha256-QT04tvgx/e3e3V2jvB9cyWarXZ5t8nhLjmbSoPtx5s8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    alsa-lib
  ];

  meta = with lib; {
    description = "An online dictionary using Youdao dict api";
    homepage = "https://github.com/LighghtEeloo/Charcoal";
    license = licenses.mit;
    mainProgram = "charcoal";
    maintainers = with maintainers; [ zendo ];
  };
}
