{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config

, libX11
, libXext
, libXi
, libXrandr
, libXinerama
, libXcursor

, libGL
, libGLU

, mpv
, gtk3
, wrapGAppsHook
, freetype
, fontconfig
}:

# Cannot load libcuda.so.1
stdenv.mkDerivation rec {
  pname = "implay";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = "ImPlay";
    rev = version;
    hash = "sha256-XAh3dSSJWgJ9Z6TX/qtUW9UtRB0/p5r2kdaLZAgVhwk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    # xorg
    libX11
    libXext
    libXi
    libXrandr
    libXinerama
    libXcursor

    # opengl
    libGL
    libGLU

    mpv
    gtk3
    freetype
    fontconfig
  ];


  meta = with lib; {
    description = "A Cross-Platform Desktop Media Player based mpv";
    homepage = "https://github.com/tsl0922/ImPlay";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "ImPlay";
    maintainers = with maintainers; [ zendo ];
  };
}
