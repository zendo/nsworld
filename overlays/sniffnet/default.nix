{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, libpcap
, freetype
, fontconfig
, wayland
, xorg
, libGL
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffnet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "GyulyVGC";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MrRav7E3UHJYM4RMio4GU0qUXTbIxtzKYAMCVvcSIsM=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-u+7Mzx2rtVUfss8W59vHldBlhFtClcGnQcuAWFO+fvc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpcap
    fontconfig
    xorg.libXi
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
  ];

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        libpcap
        stdenv.cc.cc.lib
        freetype
        fontconfig
        xorg.libXi
        xorg.libX11
        xorg.libXrandr
        xorg.libXcursor
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/$pname"
    '';

  meta = with lib; {
    description = "Cross-platform application to monitor your network traffic with ease";
    homepage = "https://github.com/GyulyVGC/sniffnet";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
