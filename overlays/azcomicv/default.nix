{ lib
, stdenv
, fetchFromGitLab
, ninja
, pkg-config
, wrapGAppsHook
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
    ninja
    pkg-config
    wrapGAppsHook
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

  buildPhase = ''
    cd build
    ninja
    ninja install
  '';

  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with lib; {
    description = "A simple comic reader";
    homepage = "http://azsky2.html.xdomain.jp/soft/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
