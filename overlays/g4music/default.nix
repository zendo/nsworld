{ lib
, stdenv
, fetchFromGitLab
, vala
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, dbus
  , tracker
, taglib
, gst_all_1
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "g4music";
  version = "1.8.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "neithern";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jLgahCG71I8jxryFR91/t7f3xcmek95I1NCPMikiWIU=";
  };

  # patches = [ ./meson-build.patch ];

  nativeBuildInputs = [
    vala
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
    dbus
    # tracker
    # taglib
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  # postPatch = ''
  #   substituteInPlace data/meson.build \
  #     --replace "get_option('datadir') / 'glib-2.0' / 'schemas'" "gschema_dir"
  # '';
  # postInstall = ''
  #   cp -r ./* $out/share/glib-2.0
  # '';

  meta = with lib; {
    description = "A beautiful, fast, fluent, light weight music player";
    homepage = "https://gitlab.gnome.org/neithern/g4music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
