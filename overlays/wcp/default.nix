{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, boost
, freetype
, libpng
, libpng12
, pngpp
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

  # dontAddStaticConfigureFlags = true;

  # dontDisableStatic = false;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libpng
  ];

  buildInputs = [
    freetype
    libpng
    wayland
    wayland-protocols
  ];

  # postPatch = ''
  #   substituteInPlace meson.build \
  #     --replace "png = cc.find_library('png',static:false)" " "
  # '';

  meta = with lib; {
    description = "Panel/system menu for wayland";
    homepage = "https://github.com/milgra/wcp";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
