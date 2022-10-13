{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, freetype
, libpng
, wayland
, wayland-protocols
}:
# WIP: no cargo.lock
rustPlatform.buildRustPackage rec {
  pname = "hybridbar";
  version = "unstable-2022-10-10";

  src = fetchFromGitHub {
    owner = "vars1ty";
    repo = "HybridBar";
    rev = "844fba7ffab44a68431540d12d089911aab351fa";
    hash = "sha256-4ypwaCylOdrVaoZKwnHOCR7WGrCD3z99xnNdKzoeZdY=";
  };

  cargoHash = "sha256-eXCbTM6+oLRIY4LIlrFs53V8IqYGhZyku48AgXmeYs8=";

  nativeBuildInputs = [
    # pkg-config
  ];

  buildInputs = [
  ];

  meta = with lib; {
    description = "Previews for lf file manager";
    homepage = "https://github.com/milgra/wcp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
}
