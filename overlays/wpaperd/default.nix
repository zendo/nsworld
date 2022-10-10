{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libxkbcommon
}:

rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = version;
    hash = "sha256-n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
  };

  cargoHash = "sha256-8ZMdbJvedDqoDr2rhKM1TMB5N4aRde04x/9H212fe68=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  meta = with lib; {
    description = "Wallpaper daemon for Wayland";
    homepage = "https://github.com/danyspin97/wpaperd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
