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
  version = "0.52";

  src = fetchFromGitHub {
    owner = "milgra";
    repo = pname;
    rev = version;
    hash = "sha256-m2pPxqD1c0HX7jg1q6PspO/897tYK+479M7Lp3OTO/o=";
  };

  depsBuildBuild = [
    libpng
    freetype
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
