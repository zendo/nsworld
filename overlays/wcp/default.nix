{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
  , freetype
    , libpng
      , wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wcp";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = pname;
    rev = version;
    hash = "sha256-VScD38Jip3Ns9C87c/as4MFOMStKz6qyPmifKr5VxRE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    # pkg-config
  ];

  buildInputs = [
    freetype
    libpng
    wayland
    wayland-protocols
  ];

  meta = with lib; {
    description = "Previews for lf file manager";
    homepage = "https://github.com/milgra/wcp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
