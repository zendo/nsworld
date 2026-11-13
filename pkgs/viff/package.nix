{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gitMinimal,
  cairo,
  pango,
  harfbuzz,
  fontconfig,
  freetype,
  libxcb,
  xcb-util-cursor,
  vulkan-loader,
  gtk3,
  glib,
  gdk-pixbuf,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "viff";
  version = "0.4.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "1lck";
    repo = "viff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SoJf31g6bcioD3Sx41XnuZWlnr3loWyWjGqkdpvSR/8=";
  };

  vendorHash = "sha256-mionDqQuqPKBvKL43ULf7/ARxacG3kYg4XjOzANIAFw=";

  subPackages = [ "cmd/viff" ];

  # Viva reaches every library through purego's dlopen at run time, so nothing
  # is linked and CGO buys nothing.
  env.CGO_ENABLED = "0";

  ldflags = [
    "-s"
    "-w"
    "-X=viff/internal/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  # Upstream's tests render text, open windows, spawn Git and SSH, and touch
  # local sockets: they belong to a desktop session, not the build sandbox.
  doCheck = false;

  postInstall = ''
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 assets/branding/icon-$size.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/viff.png
    done
  '';

  # git is the program's whole job; the rest are the libraries Viva dlopen()s,
  # which LD_LIBRARY_PATH has to make findable since no ELF NEEDED entry names
  # them.
  postFixup = ''
    wrapProgram $out/bin/viff \
      --prefix PATH : "${
        lib.makeBinPath [
          gitMinimal
        ]
      }" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          cairo
          pango
          harfbuzz
          fontconfig
          freetype
          libxcb
          xcb-util-cursor # themed cursors; the plain arrow falls back without it
          vulkan-loader # the renderer
          gtk3 # the GTK file chooser
          glib
          gdk-pixbuf
        ]
      }"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "viff";
      desktopName = "Viff";
      comment = "Lightweight native Git client";
      exec = "viff %U";
      icon = "viff";
      categories = [
        "Development"
        "RevisionControl"
      ];
      startupWMClass = "viff";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight native Git desktop client without an Electron or WebView runtime";
    homepage = "https://github.com/1lck/viff";
    changelog = "https://github.com/1lck/viff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "viff";
    platforms = lib.platforms.linux;
  };
})
