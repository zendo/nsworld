{ lib
, stdenv
, fetchFromGitHub
, pkgs
, pam
, scdoc
, gtk3
, glib

, pkg-config
, gtk-layer-shell
, wayland
, wayland-scanner
}:

stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VX+KSq2Xg8UsJWjJSNhtbCOwvc1SjxdlgN5tc+XQcr4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib
    scdoc
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    pam
    gtk3
    wayland
    # wayland-protocols
    # libxkbcommon
    gtk-layer-shell
  ];

  # installPhase = ''
  #   DESTDIR=$out PREFIX="" make install
  # '';

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
    ''; # Following  nixpkgs/pkgs/applications/window-managers/sway/lock.nix
    homepage = "https://github.com/jovanlanik/gtklock";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
