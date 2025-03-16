{
  lib,
  stdenv,
  fetchFromGitLab,
  ninja,
  pkg-config,
  wrapGAppsHook,
  fontconfig,
  freetype,
  libpng,
  libwebp,
  libheif,
  libtiff,
  libX11,
  libXext,
  libXcursor,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "azcomicv";
  version = "2.0.7";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = "azcomicv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-clSmzj7PyAzNa1D6WpkqefJFCvTCS/rI6N/wJ2sWkjQ=";
  };

  nativeBuildInputs = [
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libpng
    libwebp
    libheif
    libtiff
    libX11
    libXext
    libXcursor
  ];

  buildPhase = ''
    cd build
    ninja
    ninja install
  '';

  meta = {
    description = "Simple comic reader";
    homepage = "https://azelpg.gitlab.io/azsky2";
    downloadPage = "https://gitlab.com/azelpg/azcomicv";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
