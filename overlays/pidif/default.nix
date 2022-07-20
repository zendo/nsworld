{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  glib,
  gtk4,
  poppler,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "pidif";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = pname;
    rev = version;
    sha256 = "sha256-JMwXoO3sKXlzBY/z//t+nkvbaLV8zK8E+E66Rm3AtLE=";
  };

  cargoSha256 = "sha256-2zN0iT6SXoNF/11+BVLWF2AQ1hV0mjXatM8TPsAC9Yg=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [
    glib
    gtk4
    poppler
  ];

  # passthru.updateScript = nix-update-script {
  #   attrPath = pname;
  # };

  meta = with lib; {
    description = "Lightweight PDF reader that works on touch interfaces";
    homepage = "https://github.com/bjesus/pidif";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [zendo];
  };
}
