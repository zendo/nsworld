{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, libpcap
, fontconfig
, wayland
, xorg

, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
,  xorg_sys_opengl

}:
# WIP!!!
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
    # wrapGAppsHook4
    # appstream-glib
    # desktop-file-utils
  ];

  buildInputs = [
    # glib
    # gtk4
    # openssl
    libpcap
    fontconfig
    # wayland
    xorg.libXi
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg_sys_opengl
  ];

  # Needed to get openssl-sys to use pkg-config.
  # OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
