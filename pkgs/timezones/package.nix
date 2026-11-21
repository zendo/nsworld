{
  lib,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  gobject-introspection,
  graphene,
  gtk4,
  isocodes,
  libadwaita,
  libgweather,
  meson,
  ninja,
  nix-update-script,
  pango,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "timezones";
  version = "1.1.0";
  __structuredAttrs = true;

  pyproject = false;

  src = fetchFromGitHub {
    owner = "hernantz";
    repo = "timezones";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKE0zCbTPnnQ8GZAQ4pW2lML4DLam/g7ltjjrw7ayhc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    # city search and translated country names; the data tables it needs are
    # picked up from isocodes and tzdata at runtime
    libgweather
    graphene
    pango
    isocodes
  ];

  dependencies = [ python3Packages.pygobject3 ];

  # The unit tests open windows; the sandbox has no compositor.
  doCheck = false;

  # The app's GSettings schema and gresource live in its own share, which no
  # other input pulls onto XDG_DATA_DIRS.
  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "World time clocks on one shared timeline, native GTK4";
    homepage = "https://github.com/hernantz/timezones";
    changelog = "https://github.com/hernantz/timezones/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "timezones";
    platforms = lib.platforms.linux;
  };
})
