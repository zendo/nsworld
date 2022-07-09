/*
       > CMake Error: The current CMakeCache.txt directory /build/source/build/CMakeCache.txt is different than the directory /home/ali/projects/VoiceGen/build where CMakeCache.txt was created. This may result in binaries being created in the wrong place. If you are not sure, reedit the CMakeCache.txt
       > CMake Error: The source "/build/source/CMakeLists.txt" does not match the source "/home/ali/projects/VoiceGen/CMakeLists.txt" used to generate cache.  Re-run cmake with a different source directory.
*/
{ lib
, stdenv
, fetchFromGitLab
, extra-cmake-modules
, cmake
, qt5
, kio
, ki18n
, kxmlgui
, kconfig
, karchive
, kcoreaddons
, kconfigwidgets
}:

stdenv.mkDerivation rec {
  pname = "voicegen";
  version = "1.4.2";

  src = fetchFromGitLab {
    owner = "PersianGolf";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-5zgLJRseR1m9vKGloFX7aNpZicU6whGi2kvclw/swAY=";
  };

  nativeBuildInputs = [
    cmake
    # extra-cmake-modules
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    # kconfigwidgets
  ];

  # preFixup = ''
  #   rm cmake_install.cmake
  # '';

  meta = with lib; {
    description = "Qt manga reader for local files";
    homepage = "https://github.com/g-fb/mangareader";
    platforms = platforms.linux;
    license = with licenses; [ gpl3Plus cc-by-nc-sa-40 ];
    maintainers = with maintainers; [ zendo ];
  };
}
