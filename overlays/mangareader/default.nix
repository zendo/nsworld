{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, extra-cmake-modules
, cmake
, kio
, ki18n
, kxmlgui
, kconfig
, karchive
, kcoreaddons
, kconfigwidgets
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "mangareader";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "g-fb";
    repo = pname;
    rev = version;
    sha256 = "sha256-ow1EjT7WKEs9IKbRvh95ffMv8lVVgSsOWAx6iF8/D0w=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kio
    ki18n
    kxmlgui
    kconfig
    karchive
    kcoreaddons
    kconfigwidgets
  ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Qt manga reader for local files";
    homepage = "https://github.com/g-fb/mangareader";
    changelog = "https://github.com/g-fb/mangareader/releases/tag/${src.rev}";
    platforms = platforms.linux;
    license = with licenses; [ gpl3Plus cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ zendo ];
  };
}
