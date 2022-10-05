{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, pkg-config
, libjpeg
, pango
, cairo
}:

stdenv.mkDerivation rec {
  pname = "hyprpicker";
  version = "unstable-2022-09-05";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = pname;
    rev = "69dc644b9fd1cd96b0910ceadf388450982fc73d";
    hash = "sha256-btKx3UIEZEi9YuW1rv0HnhM7tO5Jfw7f2zvVpHYEJvg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    wlroots
    wayland
    wayland-protocols
    wayland-scanner
    pango
    cairo
    libjpeg
  ];

  configurePhase = ''
    runHook preConfigure
    make protocols
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/licenses}
    install -Dm755 build/hyprpicker -t $out/bin
    install -Dm644 LICENSE -t $out/share/licenses/hyprpicker
    runHook postInstall
  '';

  meta = with lib; {
    description = "A wlroots-compatible Wayland color picker";
    homepage = "https://github.com/hyprwm/hyprpicker";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
