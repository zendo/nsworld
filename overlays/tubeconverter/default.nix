{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, jsoncpp
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, yt-dlp
, ffmpeg-full
}:

stdenv.mkDerivation rec {
  pname = "tubeconverter";
  version = "2022.10.1";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTubeConverter";
    rev = version;
    hash = "sha256-OnW14PuZfNUDtsykD02TuANrZqR4sleNP0UnxWe0IbU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    jsoncpp
  ];

  # Don't install compiled binary
  postPatch = ''
    sed -i '13,14d' meson.build
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-full yt-dlp ]}"
    )
  '';

  meta = with lib; {
    description = "An easy-to-use YouTube video downloader";
    homepage = "https://github.com/nlogozzo/NickvisionTubeConverter";
    mainProgram = "org.nickvision.tubeconverter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
