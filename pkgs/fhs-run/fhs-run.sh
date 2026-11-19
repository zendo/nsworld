#!/usr/bin/env bash
# Runs a command inside the fhs-run FHS environment, unpacking AppImages first.
# Placeholders delimited by at-signs are substituted at build time, see package.nix.

set -euo pipefail

usage() {
  echo "Usage: fhs-run command-to-run args..."
}

if [ $# -eq 0 ]; then
  usage >&2
  exit 1
fi

case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  --)
    shift
    if [ $# -eq 0 ]; then
      usage >&2
      exit 1
    fi
    ;;
esac

# glib itself ships no gio modules, so TLS/proxy support has to come from here.
# Append instead of overwrite: AppImages and wrappers may already point at their
# own, and the host session usually exports this very path already.
gio_modules="@glib_networking@/lib/gio/modules"
case ":${GIO_EXTRA_MODULES:-}:" in
  *":$gio_modules:"*) ;;
  *) export GIO_EXTRA_MODULES="$gio_modules${GIO_EXTRA_MODULES:+:$GIO_EXTRA_MODULES}" ;;
esac

# Detect AppImages by filename or magic bytes. The `-f` test also keeps a FIFO or
# device node from blocking `od` forever.
appimage=
if [ -f "$1" ]; then
  case "$1" in
    *.AppImage | *.appimage)
      appimage=1
      ;;
    *)
      # `|| true` keeps a failing `od` (unreadable file) from tripping pipefail.
      case "$(od -An -tx1 -j 8 -N 3 -- "$1" 2>/dev/null | tr -d ' \n' || true)" in
      414901 | 414902)
        appimage=1
        ;;
      esac
      ;;
  esac
fi

if [ -n "$appimage" ]; then
  appimage_path="$(realpath "$1")"
  shift

  # Unpack once into a content-addressed cache and run AppRun from there. The
  # runtime's own APPIMAGE_EXTRACT_AND_RUN re-extracts the whole bundle into /tmp
  # on every start, which costs seconds and leaves a copy behind.
  # Without HOME and XDG_CACHE_HOME the fallback has to stay per-user, /tmp/.cache
  # would be shared between everyone logged in.
  cache_root="${XDG_CACHE_HOME:-${HOME:-${TMPDIR:-/tmp}/fhs-run-$(id -u)}/.cache}"
  appdir="$cache_root/fhs-run/appimage/$(sha256sum "$appimage_path" | cut -d' ' -f1)"
  if [ ! -x "$appdir/AppRun" ]; then
    partial="$appdir.tmp.$$"
    cleanup() { rm -rf "$partial"; }
    trap cleanup EXIT
    trap 'cleanup; exit 130' INT
    trap 'cleanup; exit 143' TERM
    trap 'cleanup; exit 129' HUP
    mkdir -p "$(dirname "$appdir")"
    # A run killed with SIGKILL never reaches the traps above, so its half-unpacked
    # tree would stay forever. Drop only clearly stale ones, other runs may still
    # be unpacking next to us.
    find "$(dirname "$appdir")" -maxdepth 1 -name '*.tmp.*' -mtime +1 -exec rm -rf {} + 2>/dev/null || true
    appimage-exec.sh -x "$partial" "$appimage_path"
    # appimage-exec prints "Not an AppImage file" and still exits 0, so check its
    # result instead of its status to report the real cause.
    if [ ! -x "$partial/AppRun" ]; then
      echo "fhs-run: $appimage_path: not a valid AppImage (no AppRun)" >&2
      exit 1
    fi
    # The tree is content-addressed, so replacing whatever is already there is
    # safe. A concurrent run may have won the race and built the same directory
    # already: keep its tree then and only drop our copy, never delete a tree that
    # another process may be executing right now.
    if ! mv -T "$partial" "$appdir" 2>/dev/null; then
      if [ -x "$appdir/AppRun" ]; then
        rm -rf "$partial"
      else
        rm -rf "$appdir"
        mv -T "$partial" "$appdir" 2>/dev/null || rm -rf "$partial"
      fi
    fi
    trap - EXIT INT TERM HUP
  fi
  if [ ! -x "$appdir/AppRun" ]; then
    echo "fhs-run: $appimage_path: failed to unpack into $appdir" >&2
    exit 1
  fi

  # What the AppImage runtime would normally provide; bundles resolve their own
  # resources through these.
  OWD="$(pwd)"
  export APPDIR="$appdir" APPIMAGE="$appimage_path" OWD
  # Hide host module paths so a bundle loads its own libraries instead of the
  # mismatched ones from the Nix profiles. GIO_EXTRA_MODULES is deliberately kept:
  # its module ABI is stable, and bundles without gio modules get TLS.
  unset QT_PLUGIN_PATH QML2_IMPORT_PATH QTWEBKIT_PLUGIN_PATH GTK_PATH GTK_EXE_PREFIX GTK_DATA_PREFIX \
    GDK_PIXBUF_MODULE_FILE GDK_PIXBUF_MODULEDIR PYTHONPATH PYTHONHOME
  # Preload the FHS copy of every Wayland library the bundle might ship, so it
  # cannot mix its own cursor/EGL with our client (or the other way round).
  # FHS_RUN_WAYLAND_PRELOAD=0 opts out for bundles pinned to their own.
  if [ "${FHS_RUN_WAYLAND_PRELOAD:-1}" != 0 ]; then
    wayland_preload=
    for lib in libwayland-client.so.0 libwayland-cursor.so.0 libwayland-egl.so.1; do
      if [ -e "/usr/lib64/$lib" ]; then
        wayland_preload="${wayland_preload:+$wayland_preload:}/usr/lib64/$lib"
      fi
    done
    if [ -n "$wayland_preload" ]; then
      export LD_PRELOAD="$wayland_preload${LD_PRELOAD:+:$LD_PRELOAD}"
    fi
  fi
  # Use the host's GL/EGL/VA/Vulkan drivers; NixOS keeps them outside /usr.
  if [ -d /run/opengl-driver ]; then
    export __EGL_VENDOR_LIBRARY_DIRS="/run/opengl-driver/share/glvnd/egl_vendor.d${__EGL_VENDOR_LIBRARY_DIRS:+:$__EGL_VENDOR_LIBRARY_DIRS}"
    export LIBGL_DRIVERS_PATH="/run/opengl-driver/lib/dri${LIBGL_DRIVERS_PATH:+:$LIBGL_DRIVERS_PATH}"
    export LIBVA_DRIVERS_PATH="/run/opengl-driver/lib/dri${LIBVA_DRIVERS_PATH:+:$LIBVA_DRIVERS_PATH}"
    # VK_DRIVER_FILES wants the json files, not their directory, so list them.
    vk_icds=
    for icd in /run/opengl-driver/share/vulkan/icd.d/*.json; do
      [ -e "$icd" ] || continue
      vk_icds="${vk_icds:+$vk_icds:}$icd"
    done
    if [ -n "$vk_icds" ]; then
      export VK_DRIVER_FILES="${VK_DRIVER_FILES:+$VK_DRIVER_FILES:}$vk_icds"
    fi
  fi

  set -- "$appdir/AppRun" "$@"
fi

# `command -v` only searches PATH, so a bare file name in the current directory
# (`fhs-run downloaded-app`) would be reported as missing. Shells do not search
# the cwd for exec either, so make the path explicit rather than adding "." to PATH.
case "$1" in
  */*) ;;
  *)
    if ! command -v "$1" >/dev/null 2>&1 && [ -e "./$1" ]; then
      set -- "./$1" "${@:2}"
    fi
    ;;
esac

if [ "${1#*/}" != "$1" ]; then
  # Looks like a path: exec would fail with a bare "Permission denied", so say
  # what is wrong. A directory passes -x, hence the -f test.
  if [ ! -e "$1" ]; then
    echo "fhs-run: $1: no such file" >&2
    exit 127
  fi
  if [ ! -f "$1" ] || [ ! -x "$1" ]; then
    echo "fhs-run: $1: not executable" >&2
    exit 127
  fi
elif ! command -v "$1" >/dev/null 2>&1; then
  echo "fhs-run: $1: command not found" >&2
  exit 127
fi

exec "$@"
