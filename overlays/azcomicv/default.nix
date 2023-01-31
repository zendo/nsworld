{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config

, libX11
, libXext
, libXcursor

, libpng
, libwebp
, libheif
, libtiff
, freetype
, fontconfig
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "azcomicv";
  version = "2.0.5";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bVxwW867pBqM8s1fX54MrnGQTKXKRTLGqJltg8k+8o8=";
  };

  nativeBuildInputs = [
    # meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libX11
    libXext
    libXcursor
    libpng
    libwebp
    libheif
    libtiff
    freetype
    fontconfig
  ];

  meta = with lib; {
    description = "Linux 用漫画ビューア";
    homepage = "https://gitlab.com/azelpg/azcomicv";
    changelog = "https://gitlab.com/azelpg/azcomicv/-/blob/${src.rev}/ChangeLog";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
