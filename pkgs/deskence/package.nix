{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  glib,
  gtk4,
  libadwaita,
  gdk-pixbuf,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  python3,
  nix-update-script,
}:

let
  # The settings application and the desktop icons helper are Python, and both
  # are installed with a shebang pointing at this interpreter.
  pythonEnv = python3.withPackages (ps: [
    ps.pygobject3
    ps.pycairo
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "deskence";
  version = "0.14.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grochala";
    repo = "deskence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k1E8PPRfRZ4mOUEl4Yiv2xRkDKaBgceTFoUiA7ZFcBA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    glib
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
    pythonEnv
  ];

  buildInputs = [
    gtk4
    libadwaita
    gdk-pixbuf
  ];

  # The unit tests need pytest, gjs, appstreamcli and groff; the release
  # packages build with the same option and validate the same files separately.
  mesonFlags = [ "-Dtests=false" ];

  # GNOME Shell only falls back to the default schema source for a system
  # extension installed in the shell's own prefix, and a Nix store prefix is
  # never that prefix. It reads <extension>/schemas/ before that fallback, so
  # give every extension its own compiled copy of the schemas.
  postInstall = ''
    for extension in $out/share/gnome-shell/extensions/*; do
      mkdir -p "$extension/schemas"
      cp "$out/share/glib-2.0/schemas/"*.gschema.xml "$extension/schemas/"
      glib-compile-schemas "$extension/schemas"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GNOME enhancement suite: dock, desktop icons, clipboard history and more";
    homepage = "https://github.com/grochala/deskence";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "deskence";
  };
})
