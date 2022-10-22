{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, cairo
, gtk3
, gtk-layer-shell

, freetype
, libpng
, wayland
, wayland-protocols
}:

rustPlatform.buildRustPackage rec {
  pname = "hybrid-bar";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "vars1ty";
    repo = "HybridBar";
    rev = version;
    hash = "sha256-Mi/bk3VuxLt/aHL8DmXfHP/0r9Y4ijFySHgVMDiB1HI=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-joQ9A8hcorVOI+XxqMHMZqApvtt1vcN/fU8xq7St69M=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    # cairo
    gtk3
    gtk-layer-shell
  ];

  meta = with lib; {
    description = "A status bar focused on wlroots Wayland compositors";
    homepage = "https://github.com/vars1ty/HybridBar";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
