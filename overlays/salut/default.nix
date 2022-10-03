{ lib, stdenv, fetchFromGitLab, rustPlatform, meson, ninja, pkg-config, scdoc
, systemd, pango, cairo, gdk-pixbuf
, wayland, wayland-protocols
, wrapGAppsHook }:

rustPlatform.buildRustPackage rec {
  pname = "salut";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vsWURLlypINcH/X2lq8IsflBstzBsH/AahIZajBRr4E=";
  };

  cargoHash = "sha256-eXCbTM6+oLRIddLIlrFs53V8IqYGhZyku48AgXmeYs8=";

  nativeBuildInputs = [ pkg-config scdoc wayland-protocols wrapGAppsHook ];
  buildInputs = [ systemd pango cairo gdk-pixbuf wayland ];

  meta = with lib; {
    description = "A lightweight Wayland notification daemon";
    homepage = "https://gitlab.com/snakedye/snui-adwaita";
    license = licenses.mpl20;
    maintainers = with maintainers; [ zendo ];
  };
}
