{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, makeWrapper
, mpv
, yt-dlp
}:

rustPlatform.buildRustPackage rec {
  pname = "radio-cli";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "margual56";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zmC8ovt43ZEZpwTAZtFkz65wBvUR/1ckGS7r3Px3SXE=";
  };

  cargoHash = "sha256-vT/nUI5hZivAEaCdz32nHaspXORQ0/rODSkX2GFpZbM=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  preFixup = ''
    wrapProgram $out/bin/radio-cli \
      --prefix PATH ":" "${lib.makeBinPath [ mpv yt-dlp ]}";
  '';

  meta = with lib; {
    description = "A simple radio CLI written in rust";
    homepage = "https://github.com/margual56/radio-cli";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
