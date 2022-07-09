/*
../src/async-task.vala:11.21-11.24: warning: copying delegates is not supported
   11 |             _task = task;
      |                     ^~~~
../src/async-task.vala:12.25-12.32: warning: copying delegates is not supported
   12 |             _callback = callback;
      |                         ^~~~~~~~
Compilation succeeded - 2 warning(s)
[15/33] Compiling C object src/g4music.p/meson-generated_portal.c.o
FAILED: src/g4music.p/meson-generated_portal.c.o
gcc -Isrc/g4music.p -Isrc -I../src -I/nix/store/0a9b4bv93s2b94q0fa2h4r0m55qy92fx-glib-2.72.3-dev/include -I/nix/store/0a9b4bv93s2b94q0fa2h4r0m55qy92fx-glib-2.72.3-dev>
src/g4music.p/portal.c:11:10: fatal error: gio/gunixfdlist.h: No such file or directory
   11 | #include <gio/gunixfdlist.h>

*/
{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  cmake,
  gtk4,
  glib,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  gst_all_1,
  dbus,
  m4,
  reuse,
}:
stdenv.mkDerivation rec {
  pname = "g4music";
  version = "1.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "neithern";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0XEReDkKpbJQQ2kdO7/DGrGlnoSfPd9ZOC/W5kZ876w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    cmake
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
    ]
    ++ (with gst_all_1; [
      gstreamer
      # gst-editing-services
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      # gst-libav
    ]);

  # postPatch = ''
  #   # GLib 2.72 moved the file from gio-unix-2.0 to gio-2.0
  #   substituteInPlace cmake/find-modules/FindGLIB.cmake \
  #     --replace gio/gunixconnection.h gio/gunixfdlist.h
  # '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/amberol";
    description = "A small and simple sound and music player";
    maintainers = with maintainers; [linsui];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
