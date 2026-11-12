{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  webkitgtk_4_1,
  glib,
  glib-networking,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

let
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "2hjaito";
    repo = "davish";
    tag = "v${version}";
    hash = "sha256-1F0E3J9/ifuLpmfJsuc0daDNtAcjnhmFYyjr61G9Hrg=";
  };

  # main.go embeds frontend/dist, so the Svelte app is built first and handed
  # to the Go build below.
  frontend = buildNpmPackage {
    pname = "davish-frontend";
    inherit version src;

    sourceRoot = "${src.name}/frontend";
    npmDepsHash = "sha256-PtnAwX6ANW7JlvP1IzXvBgVyYa6tsIQSozDtwsF5Xoo=";

    buildPhase = ''
      runHook preBuild
      npm run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/. $out/
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "davish";
  inherit version src;

  vendorHash = "sha256-2iCtPvM7ZTHmGYLwun+nGlCxdG+NqhZ6biqT27t1AXA=";

  # Only the app: cmd/updatesign is the maintainer's release-signing tool.
  subPackages = [ "." ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    glib
    glib-networking # TLS for the webview
  ];

  # What `wails build -tags webkit2_41` passes on Linux.
  tags = [
    "production"
    "desktop"
    "webkit2_41"
  ];

  preBuild = ''
    mkdir -p frontend/dist
    cp -r ${frontend}/. frontend/dist/
  '';

  # WebKitGTK's accelerated compositing is what makes this app stutter on a
  # HiDPI (2880x1800, 200%) KDE Wayland session: the WebKitWebProcess holds a
  # third of a core repainting the window through dmabuf. Painting in software
  # paces better. --set-default leaves a user override possible.
  preFixup = ''
    gappsWrapperArgs+=(--set-default WEBKIT_DISABLE_COMPOSITING_MODE 1)
  '';

  # Upstream ships no Linux desktop file; the icon is the one it uses for the
  # macOS bundle and the Windows installer.
  desktopItems = [
    (makeDesktopItem {
      name = "davish";
      desktopName = "Davish";
      comment = "Manage Linux servers over SSH without installing anything on them";
      exec = "davish";
      icon = "davish";
      categories = [
        "Development"
        "Network"
      ];
      startupWMClass = "Davish";
    })
  ];

  postInstall = ''
    install -Dm644 build/appicon.png $out/share/icons/hicolor/512x512/apps/davish.png
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop app that manages Linux servers over SSH";
    homepage = "https://github.com/2hjaito/davish";
    changelog = "https://github.com/2hjaito/davish/blob/v${version}/CHANGELOG.en.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "davish";
    platforms = lib.platforms.linux;
  };
}
