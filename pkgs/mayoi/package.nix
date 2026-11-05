{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  makeWrapper,
  wrapGAppsHook3,
  makeDesktopItem,
  gtk3,
  glib,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  libepoxy,
  libGL,
  libX11,
  webkitgtk_4_1,
  libsoup_3,
  libayatana-appindicator,
  fontconfig,
  freetype,
  harfbuzz,
  wayland,
  nix-update-script,
}:

let
  runtimeLibs = [
    gtk3
    glib
    gdk-pixbuf
    cairo
    pango
    atk
    libepoxy
    libGL
    libX11
    webkitgtk_4_1
    libsoup_3
    libayatana-appindicator
    fontconfig
    freetype
    harfbuzz
    wayland
  ];

  desktopItem = makeDesktopItem {
    name = "mayoi";
    desktopName = "Mayoi";
    comment = "A small, fast code editor";
    exec = "mayoi %F";
    icon = "mayoi";
    categories = [
      "Development"
      "TextEditor"
      "Utility"
    ];
    mimeTypes = [ "text/plain" ];
  };
in
buildGo127Module (finalAttrs: {
  pname = "mayoi";
  version = "0.18.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sorrycc";
    repo = "Mayoi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nAQQwNMvw4A1/bHF1KV0q+/HiI79ey6i4j4A8e8E6so=";
  };

  vendorHash = "sha256-vDt22hyHn/g9gfv4DV7EY3kM02rjfn72cUcFGvU3PFA=";

  subPackages = [ "cmd/mayoi" ];
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/egoist/mygo.packageName=Mayoi"
    "-X=github.com/egoist/mygo.packageVersion=${finalAttrs.version}"
    "-X=github.com/egoist/mygo.packageIdentifier=dev.mayoi.editor"
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibs;

  # MyGo loads GTK, WebKitGTK and the other libraries with purego at run
  # time, so their directories must be on LD_LIBRARY_PATH.
  dontWrapGApps = true;
  postFixup = ''
    wrapProgram "$out/bin/mayoi" \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"
  '';

  postInstall = ''
    install -Dm644 ${desktopItem}/share/applications/mayoi.desktop "$out/share/applications/mayoi.desktop"
    install -Dm644 resources/icon.png "$out/share/icons/hicolor/1024x1024/apps/mayoi.png"
  '';

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A small, fast code editor written in Go";
    homepage = "https://github.com/sorrycc/Mayoi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mayoi";
    platforms = lib.platforms.linux;
  };
})
