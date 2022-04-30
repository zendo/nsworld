{ lib, stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "newaita-reborn-icon-theme";
  version = "unstable-2022-03-18";

  src = fetchFromGitHub {
    owner = "cbrnix";
    repo = "Newaita-reborn";
    rev = "5b19f46a4ca918585038547b27810502a5997401";
    sha256 = "sha256-nA0l+xH9BlxID0lsXkojKvQRZgkJulSWsRinDre0oW8=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Newaita* $out/share/icons
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Remaster Newaita icon theme. Refreshed and made cleaner";
    homepage = "https://github.com/cbrnix/Newaita-reborn";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [zendo];
  };
}
